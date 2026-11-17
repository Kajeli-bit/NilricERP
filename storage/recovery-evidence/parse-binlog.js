// Reads a MySQL 8 binlog stream on stdin and reports the event map needed for a
// point-in-time replay.
const chunks = [];
process.stdin.on('data', (c) => chunks.push(c));
process.stdin.on('end', () => {
  const b = Buffer.concat(chunks);
  const tables = new Map();
  const writes = new Map();
  let off = 4, rowEvents = 0, lastXid = 0, first = null, last = null;
  const ddl = [], dml = [];
  while (off + 19 <= b.length) {
    const size = b.readUInt32LE(off + 9);
    const type = b[off + 4];
    const start = off + 4;
    const next = b.readUInt32LE(off + 13);
    if (size < 19 || off + size > b.length) break;
    if (!first) first = start;
    last = { pos: start, end: next, size };
    if (type === 16) lastXid = next;
    if (type === 2) {
      const p = off + 19;
      const dbLen = b[p + 8];
      const status = b.readUInt16LE(p + 11);
      const db = b.subarray(p + 13 + status, p + 13 + status + dbLen).toString();
      const q = b.subarray(p + 13 + status + dbLen + 1, off + size - 4).toString().replace(/\0+$/g, '');
      if (/^(drop database|drop table|truncate)/i.test(q)) ddl.push({ pos: start, end: next, db, sql: q.slice(0, 130) });
      else if (/^(create database|create table|insert into|update |delete from|alter table|rename table)/i.test(q)) dml.push({ pos: start, db, sql: q.slice(0, 80) });
    } else if (type === 19) {
      const p = off + 19;
      const tableId = b.readUIntLE(p, 6);
      const dbLen = b[p + 8];
      const db = b.subarray(p + 9, p + 9 + dbLen).toString();
      const tStart = p + 9 + dbLen + 1;
      const tableLen = b[tStart];
      const table = b.subarray(tStart + 1, tStart + 1 + tableLen).toString();
      tables.set(tableId, db + '.' + table);
    } else if ([23, 24, 25, 30, 31, 32].includes(type)) {
      const tableId = b.readUIntLE(off + 19, 6);
      const name = tables.get(tableId) || ('table-' + tableId);
      writes.set(name, (writes.get(name) || 0) + 1);
      rowEvents += 1;
    }
    off += size;
  }
  console.log(JSON.stringify({
    bytes: b.length, firstEvent: first, lastEvent: last, lastTransactionEnd: lastXid,
    rowEvents, rowEventsByTable: Object.fromEntries([...writes.entries()].sort((a, c) => c[1] - a[1]).slice(0, 40)),
    destructive: ddl, statementEventCount: dml.length, firstStatements: dml.slice(0, 12)
  }, null, 2));
});

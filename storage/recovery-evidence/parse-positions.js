const chunks = [];
process.stdin.on('data', (c) => chunks.push(c));
process.stdin.on('end', () => {
  const b = Buffer.concat(chunks);
  const tables = new Map();
  const spans = new Map(); // name -> {first,last,count}
  const ddls = [];
  let off = 4;
  while (off + 19 <= b.length) {
    const size = b.readUInt32LE(off + 9);
    const type = b[off + 4];
    const start = off + 4;
    if (size < 19 || off + size > b.length) break;
    if (type === 2) {
      const p = off + 19;
      const dbLen = b[p + 8];
      const status = b.readUInt16LE(p + 11);
      const db = b.subarray(p + 13 + status, p + 13 + status + dbLen).toString();
      const q = b.subarray(p + 13 + status + dbLen + 1, off + size - 4).toString().replace(/\0+$/g, '');
      if (/^(create database|drop database|create table|drop table|alter table|truncate|rename table)/i.test(q)) {
        ddls.push({ pos: start, db, sql: q.slice(0, 100) });
      }
    } else if (type === 19) {
      const p = off + 19;
      const tableId = b.readUIntLE(p, 6);
      const dbLen = b[p + 8];
      const db = b.subarray(p + 9, p + 9 + dbLen).toString();
      const tStart = p + 9 + dbLen + 1;
      const tableLen = b[tStart];
      tables.set(tableId, db + '.' + b.subarray(tStart + 1, tStart + 1 + tableLen).toString());
    } else if ([23, 24, 25, 30, 31, 32].includes(type)) {
      const name = tables.get(b.readUIntLE(off + 19, 6)) || 'unknown';
      const s = spans.get(name) || { first: start, last: start, count: 0 };
      s.last = start; s.count++;
      spans.set(name, s);
    }
    off += size;
  }
  const keep = /companies|users|employees_employees|employees_departments|employees_job_positions|partners_partners|roles|model_has_roles|user_allowed_companies|settings|plugins|permissions$/;
  const relevant = {};
  for (const [k, v] of spans) if (keep.test(k)) relevant[k] = v;
  console.log(JSON.stringify({
    firstDdls: ddls.slice(0, 6),
    totalDdls: ddls.length,
    dropDatabase: ddls.filter(d => /^drop database/i.test(d.sql)),
    relevantRowSpans: relevant
  }, null, 2));
});

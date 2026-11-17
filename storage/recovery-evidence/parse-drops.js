const chunks = [];
process.stdin.on('data', (c) => chunks.push(c));
process.stdin.on('end', () => {
  const b = Buffer.concat(chunks);
  let off = 4;
  const drops = [];
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
      if (/^drop table/i.test(q)) {
        const tables = (q.match(/`[a-z0-9_]+`/gi) || []).length;
        drops.push({ pos: start, ts: new Date(b.readUInt32LE(off) * 1000).toISOString(), db, tables });
      }
    }
    off += size;
  }
  console.log(JSON.stringify(drops, null, 0));
});

const chunks = [];
process.stdin.on('data', (c) => chunks.push(c));
process.stdin.on('end', () => {
  const b = Buffer.concat(chunks);
  const [from, to] = process.argv.slice(2).map(Number);
  const names = {2:'QUERY',4:'ROTATE',8:'INTVAR',13:'RAND',16:'XID',19:'TABLE_MAP',23:'WRITE_ROWS',24:'UPDATE_ROWS',25:'DELETE_ROWS',30:'WRITE_ROWS',31:'UPDATE_ROWS',32:'DELETE_ROWS',35:'PREV_GTIDS',36:'TRANSACTION_PAYLOAD',40:'ROWS_QUERY'};
  let off = 4;
  let lastXidBefore = null;
  while (off + 19 <= b.length) {
    const size = b.readUInt32LE(off + 9);
    const type = b[off + 4];
    const start = off + 4;
    const end = b.readUInt32LE(off + 13);
    if (size < 19 || off + size > b.length) break;
    if (type === 16 && end <= to) lastXidBefore = end;
    if (start >= from && start <= to) {
      let extra = '';
      if (type === 2) {
        const p = off + 19, dbLen = b[p + 8], status = b.readUInt16LE(p + 11);
        const db = b.subarray(p + 13 + status, p + 13 + status + dbLen).toString();
        extra = db + ' :: ' + b.subarray(p + 13 + status + dbLen + 1, off + size - 4).toString().replace(/\0+$/g, '').slice(0, 90);
      }
      console.log(start + '-' + end + ' ' + (names[type] || type) + ' ' + extra);
    }
    off += size;
  }
  console.log('last xid ending before window target: ' + lastXidBefore);
});

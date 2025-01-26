// Execute the Shell script.
// https://github.com/actions-bash/node/blob/v2.0.1/index.js
require('child_process')
  .spawn('bash', [__dirname + '/entrypoint.sh'], {
    cwd: __dirname,
    stdio: 'inherit'
  })
  .on('exit', process.exit);

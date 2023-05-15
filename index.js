// Execute the Shell script.
// https://github.com/actions-bash/node/blob/v1.0.2/index.js
require('child_process').spawn('bash', [__dirname + '/entrypoint.sh'], { stdio: 'inherit' }).on('close', code => process.exitCode = code);
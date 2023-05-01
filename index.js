// Execute the Shell script.
// https://github.com/actions-bash/node/blob/v1.0.1/index.js
require('child_process').spawn('bash',['./entrypoint.sh'],{stdio:'inherit'}).on('close',code=>process.exit(code));
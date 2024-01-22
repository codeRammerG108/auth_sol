// import * as path from 'path';
// import * as esbuild from 'esbuild';
 
// const configPath = path.resolve(__dirname, 'esbuild.config.json');
// const config = require(configPath) as esbuild.BuildOptions;
 
// for (const entryPoint of config.entryPoints) {
//   const filename = path.basename(entryPoint);
//   const outFilename = `${filename.slice(0, -3)}.mjs`;
//   const outDir = path.join(config.outdir, filename.slice(0, -3));
 
//   fs.mkdirSync(outDir, { recursive: true });
 
//   config.define.FILENAME_PLACEHOLDER = outDir + '/';
 
//   await esbuild.build({
//     ...config,
//     write: false,
//   })
//     .then((result) => {
//       fs.writeFileSync(path.join(outDir, outFilename), result.outputFiles[0].text);
//     })
//     .catch((error) => {
//       console.error(error);
//     });
 
//   config.define.FILENAME_PLACEHOLDER = '';
// }t resolvedPath = await resolve(entryPoint);
// //                         const targetDir = resolvedPath.replace(/\.ts$/, '');
// //                         await build.mkdir(targetDir);
// //                     });
// //                 });
// //                 build.onResolve({ filter: /^custom-auth/ }, (args) => {
// //                     const path = args.path;
// //                     const filename = path.split("/").pop();
// //                     const outDir = `${path.replace(/\.ts$/, '').replace('custom-auth/', 'dist/service/custom-auth/')}`;
// //                     console.log("OutDIr", outDir);
// //                     return {
// //                         path,
// //                         namespace: "file-" + filename,
// //                         outfile: `${outDir}/index.mjs`,
// //                     };
// //                 });
// //             },
// //         },
// //     ],
// // });

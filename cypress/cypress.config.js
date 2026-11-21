const { defineConfig } = require('cypress')
const fs = require('node:fs')
const path = require('node:path')

module.exports = defineConfig({
  viewportWidth: 1280,
  viewportHeight: 1600,
  defaultCommandTimeout: 10000,
  video: true,
  retries: 0,
  e2e: {
    setupNodeEvents(on) {
      on('after:run', results => {
        const folder = path.join(__dirname, 'evidence')
        fs.mkdirSync(folder, { recursive: true })
        fs.writeFileSync(path.join(folder, 'latest-run.json'), JSON.stringify({
          cypressVersion: results.cypressVersion,
          browserVersion: results.browserVersion,
          totalTests: results.totalTests,
          totalPassed: results.totalPassed,
          totalFailed: results.totalFailed,
          totalDuration: results.totalDuration,
          startedTestsAt: results.startedTestsAt,
          runs: results.runs.map(run => ({ spec: run.spec.relative, stats: run.stats })),
        }, null, 2))
      })
      on('task', {
        saveObservation(data) {
          const folder = path.join(__dirname, 'evidence')
          fs.mkdirSync(folder, { recursive: true })
          fs.appendFileSync(path.join(folder, 'observations.jsonl'), JSON.stringify(data) + '\n')
          return null
        },
      })
    },
  },
})

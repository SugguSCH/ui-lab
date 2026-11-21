# ui-lab

Individual Automated UI Testing lab for ITDS362.

Selected tools: **Part 3: Robot Framework** and **Part 4: Cypress**.

## Folders

- `robot/`: Robot Framework tests, reusable keywords in `resources/`, and evidence in `results/run1/` and `results/run2/`.
- `cypress/`: Cypress project, test specs in `cypress/e2e/`, reusable commands in `cypress/support/`, and screenshot/video evidence.

## Running the tests

The tests automate QP-01's seven steps in one browser, use condition-based waits, and create a timestamped `Lab Pizza` name. They never clear shared ratings. See `RESULTS.md` for actual automated results and the student's successful manual Chrome run.

Prerequisites: Chrome, Python 3.10+, Node.js 22/24/26, and a matching ChromeDriver downloaded from [Chrome for Testing](https://googlechromelabs.github.io/chrome-for-testing/), stored outside this repository. Set the actual driver path in each PowerShell terminal, for example:

```powershell
$env:CHROMEDRIVER = 'C:\drivers\chromedriver-win64\chromedriver.exe'
cd robot
python -m venv .venv
.\.venv\Scripts\python.exe -m pip install -r requirements.txt
```

After installing the dependencies and setting `CHROMEDRIVER`, run from `robot/`:

```powershell
.\.venv\Scripts\python.exe -m robot --outputdir results/run1 -v BROWSER:headlesschrome first.robot web_form.robot pizza_scenario.robot
```

For the second run, change `results/run1` to `results/run2`.

To reproduce Step 3.8 with just QP-01, list only `pizza_scenario.robot` at the end. Omit `-v BROWSER:headlesschrome` for a visible browser. Open the generated `report.html` for the summary and `log.html` for keyword details and screenshots.

Install Cypress from `ui-lab/cypress` using `npm.cmd ci` and verify it with `npx.cmd cypress verify`. Run both specs from that folder:

```powershell
npm.cmd test
```

Run twice for Step 4.8. Cypress replaces the default screenshots/videos each time, so preserve a copy of the first run before starting the second. `npm.cmd run open` opens its interactive runner. Cypress does not use ChromeDriver.

On the machine used here, the Cypress application cache is outside the repository in `week 11/.cache/Cypress`. To reuse it, set `$env:CYPRESS_CACHE_FOLDER = (Resolve-Path ..\..\.cache\Cypress).Path` while in `ui-lab/cypress`, before running Cypress. A fresh clone on another machine can use the default cache.

## Results and evidence

- `robot/results/run1/` and `run2/`: two passing full runs, each with 3 tests, XML results, HTML report/log and four QP-01 screenshots.
- `cypress/cypress/screenshots/` and `videos/`: the latest full run's three scenario screenshots and two spec videos.
- `cypress/evidence/`: both final console transcripts, summaries and real response observations; `run1/` preserves the first passing run's media.
- `robot/results/intentional-failure/` and `cypress/evidence/intentional-failure/`: the wrong-title failures required by the worksheet, kept separately from passing evidence. The committed tests check the correct title.

## Compatibility

The worksheet's Cypress 16.2.1 passed QP-01 but stopped before its second spec on this machine's Chrome 158 with `* is not a valid URL`. The repository pins **16.3.0**, which fixes that issue; see the [official changelog](https://docs.cypress.io/app/references/changelog#16-3-0). The original crash console is retained in `cypress/evidence/cypress-16.2.1-compatibility-error.txt` and is not counted as a passing full run.

## Part 0 and submission

The student completed Part 0.5 manually in Chrome Incognito: all seven steps passed for `Lab Pizza 20261121-200308`, with Pizza cutter and 500 calories per slice. The student also opened the existing Cypress E2E project, ran the web-form spec successfully through its GUI, and inspected a separate QuickPizza request through Chrome DevTools. Screenshots and the supplied request/response data are stored in `evidence/manual/`; `RESULTS.md` distinguishes these activities and their evidence from the automated runs. MyCourses submission is still pending.

Only the public demo credentials `admin/admin` from the worksheet are in the tests. Never substitute private account passwords. Submit [the public repository link](https://github.com/SugguSCH/ui-lab) on MyCourses before its posted deadline.

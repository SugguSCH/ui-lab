# UI lab results

Tool parts that I chose: **Part 3: Robot Framework** and **Part 4: Cypress**.

Execution date: **21 November 2026**, Asia/Bangkok (UTC+7). Automated results below were collected from real Chrome runs. The Part 0 walkthrough is explicitly agent-assisted rather than a student's manual run.

## Part 0

- Step 0.1, Chrome version: **158.0.8127.36**, Windows x64.
- Step 0.3, ChromeDriver version: **158.0.8127.36**, downloaded directly from Google and extracted outside the repository under `week 11/drivers/chromedriver-win64/`. Tests read its path from `CHROMEDRIVER`.
- Step 0.4, locator of Pizza, Please!: `button[name="pizza-please"]` (CSS).
- Step 0.4, locator of Excluded tools: `select[multiple]` (CSS).
- Step 0.4, locator of Must be vegetarian: `#default-checkbox` (CSS).
- Step 0.4, locator of Custom Pizza Name: `input#pizza-name` (CSS).
- Inspection confirmed **three** inputs sharing `id="floating_filled"`. The recommendation heading also uses `id="pizza-name"`, so the tag qualifier on the name input is necessary.
- Calories locator in Robot: `//label[normalize-space()='Max Calories per Slice']/preceding-sibling::input`; Cypress uses the same label's sibling input.

### Step 0.5 — assisted walkthrough, with limitations

The browser-control connection exposed the **in-app browser**, not installed Chrome. These actions were performed individually through page controls. This does **not** claim to fulfil the student's required manual Chrome run; a manual Chrome confirmation is still needed.

Test ID: **QP-01**. Title: **A custom pizza reaches the admin list**. Objective: verify request restrictions, rejection of anonymous ratings, and the admin's view of the pizza. Preconditions: QuickPizza reachable and no customer login. Data: name `Lab Pizza 20261121-184125`, limit `600`, excluded tool `Knife`, vegetarian selected, public demo admin `admin/admin`.

| Step | Action / expected result | Actual result | Pass or fail |
| --- | --- | --- | --- |
| 1 | Open home; expected heading appears | `Looking to break out of your pizza routine?` appeared | Pass |
| 2 | Enable Advanced; four fields appear | Calories, excluded tools, vegetarian checkbox and name were available | Pass |
| 3 | Enter restrictions/name; values are retained | `600`, Knife selected, vegetarian checked, exact name displayed | Pass |
| 4 | Request pizza; same name, non-Knife tool, calories ≤600 | `Lab Pizza 20261121-184125`, **Pizza cutter**, **350** calories per slice | Pass |
| 5 | Click Love it! without login; login message appears | `Please log in first.` appeared | Pass |
| 6 | Sign in at `/admin`; admin heading appears | `Latest pizza recommendations` appeared | Pass |
| 7 | Find the pizza; tool matches step 4 | Recent list did not contain this name, including after one Refresh | **Fail** |

Several minutes elapsed during tool setup between the request and admin check. The shared admin page showed a changing list of 15 recent pizzas. Limited recent history or server affinity could explain the missing name; this observation does not distinguish them. No successful manual result is fabricated. The later automated Chrome runs completed the scenario in seconds and verified their exact pizza names/tools.

## Part 3: Robot Framework

- `robot --version`: **Robot Framework 7.5.1 (Python 3.14.6 on win32)**.
- SeleniumLibrary: **6.9.0**; Selenium: **4.53.0**, pinned in `requirements.txt`.
- Step 3.2, failure message: `Title should have been 'Web Form' but was 'Web form'.` The deliberate run had 1 test, 0 passed, 1 failed; see [log](robot/results/intentional-failure/log.html). The checked-in default uses the correct `Web form`.
- Step 3.8: each recorded full suite includes the two web-form tests and QP-01, for **3 tests**.

| Run | Result / full suite elapsed | QP-01 elapsed | Pizza name | Tool | Calories |
| --- | --- | --- | --- | --- | --- |
| 1 | **PASS, 3/3, 17.092 s** | 9.678 s | Lab Pizza 20261121-184336 | Scissors | 425 |
| 2 | **PASS, 3/3, 17.802 s** | 9.700 s | Lab Pizza 20261121-184446 | Pizza cutter | 500 |

Run 1 admin row: `Lab Pizza 20261121-184336 (tool=Scissors, ingredients_number=6) (newest)`.

Run 2 admin row: `Lab Pizza 20261121-184446 (tool=Pizza cutter, ingredients_number=7) (newest)`.

Evidence: [run 1 report](robot/results/run1/report.html), [run 1 log](robot/results/run1/log.html), [run 2 report](robot/results/run2/report.html), [run 2 log](robot/results/run2/log.html). Each run includes four scenario pictures: fields, recommendation, login message and admin list. Durations come from `output.xml`, rounded to three decimal places.

A development failure occurred because locator `${PASSWORD}` collided with argument `${password}` (Robot names are case-insensitive). Renaming it `${ADMIN PASSWORD FIELD}` fixed `Element with locator 'admin' not found.` Both full runs above were recorded after that repair.

## Part 4: Cypress

- `node --version`: **v26.5.0**; `npm --version`: **11.17.0**.
- Cypress package/binary: **16.3.0** for final full runs. Initial setup and the deliberate failure used the worksheet's **16.2.1**.
- Step 4.3, real failure: `Timed out retrying after 10000ms`, actual `'Web form'`, expected `'Web Form'`; **0 passing, 1 failing**. See [console](cypress/evidence/intentional-failure-console.txt). The committed spec uses the correct title.
- Compatibility repair: 16.2.1 passed QP-01 but crashed before spec 2 with `* is not a valid URL`. Version 16.3.0 includes the [official Chrome 158 fix](https://docs.cypress.io/app/references/changelog#16-3-0). No assertion or test isolation was disabled. The aborted run is not counted as a passing full run.

Final measurements and response data are retained in `cypress/evidence/` with both full console transcripts.

| Step 4.8 run | Result | Duration from console table | Exact summed spec duration | Pizza name | Step 4.6 response tool / calories |
| --- | --- | --- | --- | --- | --- |
| 1 | **PASS, 2/2** | 00:12 | 12.000 s | Lab Pizza 20261121-184722 | Scissors / 575 |
| 2 | **PASS, 2/2** | 00:11 | 11.821 s | Lab Pizza 20261121-185024 | Pizza cutter / 500 |

Both observed POST `/api/pizza` responses returned HTTP 200 and `vegetarian: true`; the test asserts the 600-calorie request limit and compares response tool/calories with the UI. The vegetarian flag is recorded, not asserted. The observations file also retains the successful QP-01 from the aborted 16.2.1 suite; it is distinguished by its name `Lab Pizza 20261121-184523` and is not one of the final full runs.

Step 4.7, final matching admin line: `Lab Pizza 20261121-185024 (tool=Pizza cutter, ingredients_number=5) (newest)`.

Step 4.8 evidence: [run 1 console](cypress/evidence/run1-console.txt), [run 1 summary](cypress/evidence/run1-summary.json), [run 2 console](cypress/evidence/run2-console.txt), [run 2 summary](cypress/evidence/run2-summary.json). The latest videos are [QP-01](cypress/cypress/videos/pizza-scenario.cy.js.mp4) and [web form](cypress/cypress/videos/web-form.cy.js.mp4). The first run's media are preserved under `cypress/evidence/run1/`; the latest screenshots show the recommendation, rejection of anonymous rating and matching admin row.

Step 4.9 (optional): not performed; required tests use Chrome.

## Part B

1. The advanced page contains three inputs with the same `floating_filled` id, so an id-only selector cannot distinguish calories from toppings. Inspecting the live page confirmed that duplicate count. Finding the `Max Calories per Slice` label and its sibling input selects the intended field. Giving the input a unique id such as `max-calories-per-slice` and updating its label's `for` attribute would make the association unambiguous for tests and assistive technology.

2. Step 7 uses a consistency oracle, comparing two representations of the same recommendation across customer and admin views. The tool captured from step 4 becomes the expected tool in the row identified by the unique pizza name. In Robot run 1, both views showed Scissors for `Lab Pizza 20261121-184336`. This would catch a fault where the server stores the wrong tool or the admin page renders another pizza's tool beside the correct name.

3. A selected vegetarian checkbox proves the input state, not the suitability of the recommendation. An additional check could assert `vegetarian === true` on the intercepted response, alongside checking the displayed ingredients. Cypress records that response value, but this seven-step test intentionally does not assert it. A stronger independent oracle would need an authoritative ingredient-to-vegetarian mapping, because a wrong server classification could otherwise go undetected.

4. Robot explicitly waits for the heading, Knife option, recommendation, login response and admin list; Cypress retries queries/assertions and waits for its aliased pizza request. For authoring effort, this Cypress implementation puts the scenario directly in one spec, while Robot requires the scenario file plus reusable keyword definitions before the full flow is assembled. Authoring time was not measured separately, so I cannot honestly report minutes or claim a measured speed advantage for either tool. Robot's HTML log groups actions under readable names and embeds four scenario pictures, including the matching admin row for `Lab Pizza 20261121-184446`. Cypress videos show the command log and page together, making the sequence easy to inspect, while its console recorded complete suite durations of 12 and 11 seconds. The observed `* is not a valid URL` compatibility failure also added setup effort to Cypress before both specs could run together.

5. For Project 2, I would choose Cypress based on this lab. The intercept check verifies that the request carries the 600-calorie limit and that the page displays the response's tool and calories. Its generated videos and command log also make the customer-to-admin flow easy to review. I would keep its working version pinned because Chrome 158 needed the compatibility fix before both specs could run together.

6. For Part 3, a changed calories locator is repaired in `${MAX CALORIES}` inside `robot/resources/quickpizza.resource`. Both visibility checks and fill/value checks refer to that variable. `pizza_scenario.robot` calls `Fill In The Pizza Request` rather than embedding the locator, so it needs no locator change. The resource file therefore confines page structure details to one place and keeps the test readable.

7. For Part 4, all seven steps belong in one test so the pizza name, captured tool and browser cookies survive until the admin check. Cypress clears browser state between tests, including the cookie that can pin QuickPizza to one backend. Splitting steps 6–7 into another test could reach a different backend and would also lose the first test's aliases and local data. The final spec keeps both roles in one `it` block.

## Verification against the original PDF

Reviewed against the original 71-page `W11-UI_Lab_Exercise_v2.pdf`, revision 4 November 2026, rather than assuming the extracted Markdown alone was sufficient.

| PDF requirement | Evidence / status |
| --- | --- |
| Page 1: choose two tools, plus Part 0, Part B and deliverables | Robot and Cypress selected; Part 0 limitation remains as recorded above |
| Pages 40–52: Robot web-form tests, QP-01, resource keywords, deliberate title failure, two passing runs | Required source files and recorded reports/screenshots are present |
| Pages 53–65: Cypress web form, QP-01, intercept comparisons, custom login, deliberate title failure, two full runs with videos/screenshots | Required source files and recorded media are present; the documented compatibility update was necessary |
| Page 66: seven reflection answers, 3–6 sentences each | Answers present; question 4 explicitly distinguishes authoring effort from unmeasured authoring time |
| Pages 67–68: README, RESULTS, dependency files and selected tool folders with evidence pushed | Required files are tracked; dependencies and the personal local summary are excluded |
| Pages 5–6: run QP-01 by hand in Chrome and record actual results | **Still requires the student's manual Chrome run**; the assisted in-app-browser attempt is recorded separately |
| Page 67: submit repository link on MyCourses | **Not yet submitted** |

The repository contains the final implementations and their actual runs, rather than a saved version of every intermediate exercise. The guided Cypress setup wizard (Step 4.2) was replaced by creating the configuration/support files directly. The manual Chrome DevTools Network inspection in Step 4.6 was not separately completed; the test observes the real request with `cy.intercept` and records its response instead. These functional alternatives do not establish that every guided GUI action or every incremental practice run was performed. ChromeDriver was downloaded directly and used via `CHROMEDRIVER` set for the execution sessions; the README documents setting it again in a new terminal rather than claiming a persistent Windows setting was configured.

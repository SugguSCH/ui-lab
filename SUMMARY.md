# สรุปงาน UI Testing Lab — Week 11

วันที่สรุป: 21 พฤศจิกายน 2026 (เวลาไทย)

เครื่องมือที่เลือก: **Part 3: Robot Framework** และ **Part 4: Cypress**

Repository: [SugguSCH/ui-lab](https://github.com/SugguSCH/ui-lab)

## สถานะปัจจุบัน

ส่วน Automated UI Testing ของทั้งสองเครื่องมือทำแล้วและผ่านครบสองรอบ พร้อมโค้ด เอกสาร และหลักฐานบน GitHub แต่ยังมี **การยืนยัน Part 0 ด้วยมือใน Chrome** และ **การส่งลิงก์บน MyCourses** ที่ยังไม่เสร็จ รายละเอียดข้อจำกัดระบุไว้ตามผลจริงใน [RESULTS.md](RESULTS.md)

## 1. จัดโครงสร้างโฟลเดอร์และ Git

- รวม Git ที่ซ้อนกันให้เหลือ repository หลักใน `week 11/ui-lab` โดยเก็บประวัติเดิมและ remote GitHub ไว้
- สำรอง Git ที่ซ้ำไว้ใน `week 11/.local-backup/unused-nested-git` นอก repository
- แยกโฟลเดอร์งานเป็น `robot/` และ `cypress/`
- เก็บเอกสารโจทย์ ตัวติดตั้ง ChromeDriver และ cache ของ Cypress ไว้นอก repository
- เพิ่ม `.gitignore` เพื่อข้าม dependencies, Python environment, cache ของ Python, ไฟล์ตั้งค่าส่วนตัว และไฟล์ editor
- คงการติดตาม screenshots, videos และ reports ที่ใช้เป็นหลักฐานส่งงาน

## 2. เตรียมเครื่องมือ

| รายการ | เวอร์ชันที่ใช้ |
| --- | --- |
| Chrome | 158.0.8127.36 |
| ChromeDriver | 158.0.8127.36 |
| Python | 3.14.6 |
| Robot Framework | 7.5.1 |
| SeleniumLibrary | 6.9.0 |
| Selenium | 4.53.0 |
| Node.js | 26.5.0 |
| npm | 11.17.0 |
| Cypress สำหรับรันชุดสุดท้าย | 16.3.0 |

ติดตั้ง Robot ใน virtual environment และกำหนด dependencies ไว้ใน `robot/requirements.txt` ส่วน Cypress มี `package.json` และ `package-lock.json` เพื่อให้ติดตั้งซ้ำได้ ใช้ตัวแปร `CHROMEDRIVER` สำหรับ Robot โดยไม่มี path เฉพาะเครื่องฝังในไฟล์ทดสอบ

## 3. Part 0: ตรวจหน้าเว็บและ locator

- บันทึกเวอร์ชัน Chrome และ ChromeDriver
- ตรวจพบว่า input ตัวเลขสามช่องใช้ id `floating_filled` ซ้ำกัน จึงหา input แคลอรีผ่านข้อความ label
- บันทึก locator ของปุ่ม Pizza, Please!, รายการ Excluded tools, checkbox vegetarian และช่อง Custom Pizza Name
- ใช้ `input#pizza-name` เพื่อแยกช่องกรอกชื่อออกจาก heading ของผลลัพธ์ที่มี id เดียวกัน
- ทดลอง QP-01 ผ่านการควบคุมหน้าเว็บทีละขั้นในเบราว์เซอร์ภายในแอป

ผลการทดลองนั้น: ชื่อ `Lab Pizza 20261121-184125`, เครื่องมือ **Pizza cutter**, **350 แคลอรีต่อชิ้น** และแสดง `Please log in first.` เมื่อให้คะแนนโดยยังไม่ล็อกอิน ขั้นที่ 1–6 ผ่าน แต่ขั้นที่ 7 ไม่พบชื่อในรายการ admin แม้ลอง Refresh หนึ่งครั้ง จึงบันทึกเป็น **Fail**

การทดลองนี้ใช้เบราว์เซอร์ภายในแอป จึงยังไม่นับแทนการทำด้วยมือใน Chrome ตามโจทย์ และไม่ได้เปลี่ยนผลที่ไม่ผ่านให้เป็นผ่าน ส่วน Automated Chrome ของทั้งสองเครื่องมือตรวจพบชื่อและเครื่องมือตรงกันใน admin ได้จริง

## 4. Part 3: Robot Framework

ไฟล์หลักที่สร้าง:

- [first.robot](robot/first.robot): เปิด Selenium web form และตรวจชื่อหน้า
- [web_form.robot](robot/web_form.robot): กรอก text, password, textarea, select, checkbox, radio และ date แล้ว submit และตรวจ `Received!`
- [pizza_scenario.robot](robot/pizza_scenario.robot): QP-01 ครบ 7 ขั้นตอน
- [browser.resource](robot/resources/browser.resource): เปิดเบราว์เซอร์และกำหนดขนาดหน้าต่างร่วมกัน
- [quickpizza.resource](robot/resources/quickpizza.resource): รวม locator และ keywords ของ QuickPizza

ใช้การรอเงื่อนไขของหน้าเว็บแทนการหยุดรอเวลาตายตัว ชื่อพิซซ่ามีวันเวลาเพื่อไม่ชนกับข้อมูลเดิม และค้นหารายการ admin จากชื่อจริงแทนการสมมติว่าอยู่แถวแรก

ทดลองชื่อหน้าผิดตาม Step 3.2 ได้ข้อความจริงว่า `Title should have been 'Web Form' but was 'Web form'.` จากนั้นใช้ชื่อหน้าที่ถูกต้องในการรันชุดสุดท้าย

| รอบ | ผลทั้งชุด | เวลาทั้งชุด | ชื่อพิซซ่า | เครื่องมือ | แคลอรี |
| --- | --- | --- | --- | --- | --- |
| 1 | ผ่าน 3/3 tests | 17.092 วินาที | Lab Pizza 20261121-184336 | Scissors | 425 |
| 2 | ผ่าน 3/3 tests | 17.802 วินาที | Lab Pizza 20261121-184446 | Pizza cutter | 500 |

หลักฐานอยู่ใน `robot/results/run1/` และ `robot/results/run2/` แต่ละรอบมี `output.xml`, `log.html`, `report.html` และภาพ 4 ขั้นตอน ส่วนผลที่ตั้งใจให้ผิดเก็บแยกใน `robot/results/intentional-failure/`

## 5. Part 4: Cypress

ไฟล์หลักที่สร้าง:

- [web-form.cy.js](cypress/cypress/e2e/web-form.cy.js): กรอกและส่ง Selenium web form พร้อมตรวจผล
- [pizza-scenario.cy.js](cypress/cypress/e2e/pizza-scenario.cy.js): QP-01 ครบ 7 ขั้นตอนใน test เดียว
- [commands.js](cypress/cypress/support/commands.js): custom command `adminLogin`
- [e2e.js](cypress/cypress/support/e2e.js): โหลด custom commands
- [cypress.config.js](cypress/cypress.config.js): timeout, ขนาดหน้าทดสอบ, วิดีโอ และบันทึกข้อมูลผลรัน

ใช้ `cy.intercept` เฝ้าดู POST `/api/pizza` จริง ตรวจ HTTP 200 และค่าแคลอรีที่ส่งออกไป แล้วเปรียบเทียบเครื่องมือและแคลอรีจาก response กับหน้าเว็บ เก็บเครื่องมือไว้เปรียบเทียบกับรายการ admin ในขั้นสุดท้าย และคง cookies ใน test เดียวกัน

ทดลองชื่อหน้าผิดตาม Step 4.3 ได้ `Timed out retrying after 10000ms` โดยค่าจริงเป็น `Web form` แต่คาดหวัง `Web Form` แล้วคืนไฟล์ให้ตรวจชื่อที่ถูกต้อง

| รอบ | ผลทั้งชุด | เวลารวมจากผลแต่ละ spec | ชื่อพิซซ่า | เครื่องมือ | แคลอรี |
| --- | --- | --- | --- | --- | --- |
| 1 | ผ่าน 2/2 tests | 12.000 วินาที | Lab Pizza 20261121-184722 | Scissors | 575 |
| 2 | ผ่าน 2/2 tests | 11.821 วินาที | Lab Pizza 20261121-185024 | Pizza cutter | 500 |

หลักฐานรอบล่าสุด:

- `cypress/cypress/screenshots/`: ภาพคำแนะนำพิซซ่า ข้อความให้ล็อกอิน และรายการ admin
- `cypress/cypress/videos/`: วิดีโอ QP-01 และ web form
- `cypress/evidence/`: console สองรอบ, summaries และค่าที่ได้รับจริงจาก response
- `cypress/evidence/run1/`: สำเนาภาพและวิดีโอของรอบแรก

ขั้นทดสอบเบราว์เซอร์ตัวที่สองเป็น Optional จึงไม่ได้ทำ

## 6. ปัญหาที่แก้ระหว่างทำ

1. **Robot ตัวแปรชื่อชนกัน:** `${PASSWORD}` กับ argument `${password}` เป็นชื่อเดียวกันสำหรับ Robot จึงเปลี่ยนชื่อ locator เป็น `${ADMIN PASSWORD FIELD}` และรันใหม่จนผ่านสองรอบ
2. **Cypress กับ Chrome 158:** รุ่น 16.2.1 ตามโจทย์ผ่าน QP-01 แต่หยุดก่อน spec ที่สองด้วย `* is not a valid URL` จึงอัปเดตและ pin เป็น 16.3.0 ตาม [บันทึกแก้ไขของ Cypress](https://docs.cypress.io/app/references/changelog#16-3-0) แล้วรันครบสองรอบได้ ผลรันที่หยุดไม่ถูกนับเป็นรอบผ่าน

## 7. เอกสารและการตรวจงาน

- [README.md](README.md): เครื่องมือที่เลือก โฟลเดอร์ วิธีติดตั้ง คำสั่งรัน และตำแหน่งหลักฐาน
- [RESULTS.md](RESULTS.md): เวอร์ชัน, locator, ผลทดลอง, failure messages, ชื่อพิซซ่า, เวลา และ Reflection ครบ 7 ข้อ
- ตรวจผลที่บันทึกว่า Robot ผ่านครบ 3 tests และ Cypress ผ่านครบ 2 tests ทั้งสองรอบ
- เปิดตรวจภาพหลักฐานของข้อความให้ล็อกอินและรายการ admin
- ตรวจว่าไฟล์วิดีโอมีข้อมูลและมีรูปแบบ MP4 รวมทั้งตรวจลิงก์ไฟล์ภายในเอกสาร
- Commit และ push โค้ด เอกสาร และหลักฐานไปยัง GitHub แล้ว

## 8. สิ่งที่ยังต้องทำก่อนส่ง

### ยืนยัน Part 0 ด้วยมือใน Chrome

- [ ] เปิด Chrome โดยยังไม่ล็อกอิน QuickPizza แล้วเข้า [หน้า QuickPizza](https://quickpizza.grafana.com)
- [ ] ตรวจ heading แล้วเปิด Advanced
- [ ] ใส่แคลอรี 600, เลือกไม่ใช้ Knife, ติ๊ก vegetarian และตั้งชื่อ `Lab Pizza` ตามด้วยวันเวลาใหม่
- [ ] กด Pizza, Please! แล้วจดชื่อ เครื่องมือ และแคลอรีที่แสดง
- [ ] กด Love it! แล้วตรวจ `Please log in first.`
- [ ] เข้า `/admin` ในเบราว์เซอร์เดิม ล็อกอินด้วยบัญชีตัวอย่างตามโจทย์ แล้วค้นหาชื่อที่เพิ่งสร้างและตรวจเครื่องมือให้ตรงกัน ควรทำต่อทันทีเพราะเป็นรายการล่าสุดของเว็บที่ใช้ร่วมกัน
- [ ] บันทึกผลจริงของทั้ง 7 ขั้นใน `RESULTS.md` แล้ว commit/push ผลที่อัปเดต

### ส่งงาน

- [ ] ตรวจวันกำหนดส่งจาก MyCourses เพราะเอกสารโจทย์ไม่ได้ระบุวัน
- [ ] ส่งลิงก์ `https://github.com/SugguSCH/ui-lab` บนหน้าส่งงาน MyCourses

ยังไม่ได้ส่ง MyCourses เพราะยังไม่มีลิงก์หน้าส่งงานในแชตนี้ ห้ามถือว่าการ push GitHub เท่ากับส่งงานบน MyCourses แล้ว

ไม่จำเป็นต้องรันทดสอบอัตโนมัติเพิ่มเพื่อสร้างหลักฐานซ้ำ หากไม่ได้แก้โค้ดหรือพบปัญหาใหม่ เพราะสองเครื่องมือมีผลผ่านสองรอบตามข้อกำหนดแล้ว

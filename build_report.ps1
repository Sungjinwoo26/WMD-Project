Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$out = Join-Path $PSScriptRoot 'NutriGuard_WMD_Project_Report.docx'
if (Test-Path $out) { Remove-Item -LiteralPath $out -Force }

function X([string]$s) { [System.Security.SecurityElement]::Escape($s) }
$body = New-Object System.Text.StringBuilder
function Add-P([string]$text='', [string]$align='both', [int]$size=22, [bool]$bold=$false, [int]$spaceBefore=0, [int]$spaceAfter=120, [int]$line=360, [bool]$italic=$false) {
  $b = if($bold){'<w:b/>'}else{''}; $i = if($italic){'<w:i/>'}else{''}
  $t = X $text
  [void]$body.Append("<w:p><w:pPr><w:jc w:val='$align'/><w:spacing w:before='$spaceBefore' w:after='$spaceAfter' w:line='$line' w:lineRule='auto'/></w:pPr><w:r><w:rPr><w:rFonts w:ascii='Times New Roman' w:hAnsi='Times New Roman'/><w:sz w:val='$size'/><w:szCs w:val='$size'/>$b$i</w:rPr><w:t xml:space='preserve'>$t</w:t></w:r></w:p>")
}
function Add-Blank([int]$n=1) { 1..$n | ForEach-Object { Add-P '' 'left' 22 $false 0 80 240 } }
function Add-Break { [void]$body.Append('<w:p><w:r><w:br w:type="page"/></w:r></w:p>') }
function Add-Heading([string]$text, [int]$level=1) { $size=if($level -eq 1){28}else{24}; Add-P $text 'center' $size $true 140 160 300 }
function Add-Sub([string]$text) {
  # Strip the original template bullet marker; it rendered incorrectly in some viewers.
  $text = $text -replace '^[^A-Za-z0-9]+', ''
  Add-P $text 'left' 22 $true 100 80 300
}
function Add-Table([object[]]$rows, [int[]]$widths) {
  $tbl = '<w:tbl><w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblBorders><w:top w:val="single" w:sz="4" w:color="000000"/><w:left w:val="single" w:sz="4" w:color="000000"/><w:bottom w:val="single" w:sz="4" w:color="000000"/><w:right w:val="single" w:sz="4" w:color="000000"/><w:insideH w:val="single" w:sz="4" w:color="000000"/><w:insideV w:val="single" w:sz="4" w:color="000000"/></w:tblBorders></w:tblPr><w:tblGrid>'
  foreach($w in $widths){$tbl += "<w:gridCol w:w='$w'/>"}; $tbl += '</w:tblGrid>'
  $rnum=0
  foreach($row in $rows){ $tbl += '<w:tr>'; $cnum=0; foreach($cell in $row){ $shade=if($rnum -eq 0){'<w:shd w:fill="D9EAF7"/>'}else{''}; $bold=if($rnum -eq 0){'<w:b/>'}else{''}; $width=$widths[$cnum]; $tbl += "<w:tc><w:tcPr><w:tcW w:w='$width' w:type='dxa'/>$shade<w:tcMar><w:top w:w='90' w:type='dxa'/><w:left w:w='90' w:type='dxa'/><w:bottom w:w='90' w:type='dxa'/><w:right w:w='90' w:type='dxa'/></w:tcMar></w:tcPr><w:p><w:pPr><w:spacing w:after='0' w:line='276'/></w:pPr><w:r><w:rPr><w:rFonts w:ascii='Times New Roman' w:hAnsi='Times New Roman'/><w:sz w:val='20'/>$bold</w:rPr><w:t xml:space='preserve'>$(X ([string]$cell))</w:t></w:r></w:p></w:tc>"; $cnum++ }; $tbl += '</w:tr>'; $rnum++ }
  $tbl += '</w:tbl>'; [void]$body.Append($tbl); Add-Blank 1
}
function Add-Bullet([string]$text) { Add-P ("- " + $text) 'both' 22 $false 0 65 330 }

# 1 Cover
Add-Blank 4
Add-P "PARSHVANATH CHARITABLE TRUST'S" 'center' 24 $true 60 40 300
Add-P 'A. P. SHAH INSTITUTE OF TECHNOLOGY' 'center' 30 $true 40 20 300
Add-P '(Approved by AICTE, New Delhi and Government of Maharashtra, Affiliated to University of Mumbai)' 'center' 18 $false 20 240 260
Add-P 'DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING' 'center' 24 $true 100 20 300
Add-P '(Artificial Intelligence and Machine Learning)' 'center' 22 $true 20 360 300
Add-P 'PROJECT REPORT' 'center' 30 $true 180 180 300
Add-P 'ON' 'center' 20 $true 20 120 300
Add-P 'NUTRIGUARD' 'center' 40 $true 80 60 360
Add-P 'A Nutritional Risk Classification System for Packaged Foods' 'center' 26 $true 30 300 320
Add-P 'Submitted in partial fulfilment of the requirements for the subject' 'center' 20 $false 100 40 300
Add-P 'Web and Mobile Development Laboratory' 'center' 24 $true 20 260 300
Add-P 'Submitted by' 'center' 20 $false 80 20 300
Add-P 'AKSHAT MUKKAWAR' 'center' 26 $true 20 80 300
Add-P 'Class: TE CSE (AI and ML)     Academic Year: 2026–27     Semester: V' 'center' 20 $false 60 300 300
Add-P 'Project Guide: ______________________________' 'center' 20 $false 60 0 300

# 2 Certificate
Add-Break; Add-Heading 'CERTIFICATE'; Add-Blank 2
Add-P 'This is to certify that the project report entitled “NutriGuard: A Nutritional Risk Classification System for Packaged Foods” is a bonafide work carried out by Mr. Akshat Mukkawar of Third Year, Computer Science and Engineering (Artificial Intelligence and Machine Learning), A. P. Shah Institute of Technology, during the academic year 2026–27, in partial fulfilment of the requirements for the Web and Mobile Development Laboratory.' 'both' 22 $false 0 160 390
Add-P 'The work embodied in this report has been carried out under appropriate academic guidance and has not been submitted elsewhere for any other academic award.' 'both' 22 $false 0 300 390
Add-Blank 5
Add-P '______________________________                         ______________________________' 'center' 20 $false 0 20 300
Add-P 'Project Guide                                                    Head of Department' 'center' 20 $false 0 280 300
Add-P 'Date: ____________________                                     Place: Mumbai' 'left' 20 $false 60 0 300

# 3 Declaration
Add-Break; Add-Heading 'DECLARATION'; Add-Blank 2
Add-P 'I hereby declare that the project report entitled “NutriGuard: A Nutritional Risk Classification System for Packaged Foods” is my original work completed for the Web and Mobile Development Laboratory during the academic year 2026–27. The work has been prepared under the guidance of the faculty concerned, and has not been submitted, in whole or in part, to any other university or institution for the award of any degree or diploma.' 'both' 22 $false 0 220 390
Add-P 'All ideas, references and technical resources used during the development and documentation of the project have been duly acknowledged.' 'both' 22 $false 0 320 390
Add-Blank 6
Add-P 'Signature of Student: ______________________________' 'right' 20 $false 0 40 300
Add-P 'Name: Akshat Mukkawar' 'right' 20 $false 0 20 300
Add-P 'Date: ______________________________' 'right' 20 $false 0 0 300

# 4 Acknowledgement
Add-Break; Add-Heading 'ACKNOWLEDGEMENT'; Add-Blank 1
Add-P 'I express my sincere gratitude to the Principal of A. P. Shah Institute of Technology and the Head of the Department of Computer Science and Engineering for providing the academic environment and facilities required for this project.' 'both' 22 $false 0 160 390
Add-P 'I am thankful to my project guide for valuable guidance, constructive feedback and encouragement throughout the planning, implementation and documentation of NutriGuard. I also thank the faculty members of the Web and Mobile Development Laboratory for their inputs on full-stack application development, user interface design and testing practices.' 'both' 22 $false 0 160 390
Add-P 'Finally, I acknowledge my family and friends for their support during the completion of this work.' 'both' 22 $false 0 300 390
Add-Blank 6; Add-P 'Akshat Mukkawar' 'right' 20 $true 0 0 300

# 5 Abstract
Add-Break; Add-Heading 'ABSTRACT'; Add-Blank 1
Add-P 'NutriGuard is a web-based nutritional risk classification system developed to help consumers interpret packaged-food nutrition information quickly and consistently. Product labels often present sugar, sodium, fat and additive information in a form that is difficult to compare at the point of selection. The proposed system accepts product data, evaluates it through transparent rules and presents a clear Low Risk, Moderate Risk or High Risk classification along with the nutrient values that influence the result.' 'both' 22 $false 0 130 390
Add-P 'The application is designed as a full-stack web solution. Its interface is developed with React and Vite using reusable components for the catalogue, filters, product cards and risk-assessment form. The classification engine uses defined thresholds for sugar, sodium, fat and artificial additives. The service layer is designed using Spring Boot, Spring Data JPA and an embedded relational database for product persistence; an authentication module uses Flask and JSON Web Tokens to protect user access. The design supports search, category filtering and create, read, update and delete operations on food records.' 'both' 22 $false 0 130 390
Add-P 'The result is a usable minimum viable product that demonstrates how a simple, explainable rules engine can translate nutrition data into an accessible consumer-facing health signal. The project is aligned with Sustainable Development Goal 3: Good Health and Well-being.' 'both' 22 $false 0 170 390
Add-P 'Keywords: packaged food, nutrition, nutritional risk, React, Spring Boot, REST API, JWT, rule-based classification.' 'both' 20 $true 80 0 330

# 6 Index
Add-Break; Add-Heading 'TABLE OF CONTENTS'; Add-Blank 1
Add-Table @(
 @('Section','Title','Page'),
 @('1','Introduction','7'), @('2','Problem Statement and Objectives','8'), @('3','Literature Survey and Feasibility','9'), @('4','Requirements and Methodology','10'), @('5','System Design and Architecture','11'), @('6','Implementation Details','12'), @('7','Risk Classification Model','13'), @('8','Testing and Results','14'), @('9','Conclusion and Future Scope','15'), @('','References','16')
) @(850,5100,800)

# 7 Intro
Add-Break; Add-Heading 'CHAPTER 1  INTRODUCTION'; Add-Sub '1.1 Background'
Add-P 'Packaged foods form an important part of daily consumption, yet the nutrition panel on a package is not always easy to interpret. Consumers may recognise individual values such as sugar or sodium, but it is difficult to determine how the combined values should influence a purchasing decision. NutriGuard addresses this communication gap through a focused web application that presents the relevant values and a simple risk label in one place.' 'both' 22 $false 0 120 390
Add-Sub '1.2 Purpose of the System'
Add-P 'The purpose of NutriGuard is to provide a quick product-level assessment from declared nutrition information. Instead of attempting medical diagnosis, the system offers an educational, explainable indication of whether the values require greater attention. Every classification is accompanied by the measurable factors used in the decision.' 'both' 22 $false 0 120 390
Add-Sub '1.3 Scope'
Add-Bullet 'Maintain a searchable catalogue of packaged food products and their nutrition details.'
Add-Bullet 'Classify products as Low Risk, Moderate Risk or High Risk using transparent rules.'
Add-Bullet 'Support food-record creation, editing and removal through a responsive interface.'
Add-Bullet 'Provide a backend-ready architecture for persistent data storage and authenticated use.'

# 8 Problem/obj
Add-Break; Add-Heading 'CHAPTER 2  PROBLEM STATEMENT AND OBJECTIVES'; Add-Sub '2.1 Problem Statement'
Add-P 'Consumers frequently encounter a large number of packaged-food options with different serving sizes, nutrient values and marketing claims. Comparing them manually is slow and can lead to decisions based on incomplete information. A system is required that accepts consistent product inputs and transforms them into a clear, repeatable nutritional risk indication.' 'both' 22 $false 0 160 390
Add-Sub '2.2 Objectives'
Add-Bullet 'To develop a responsive web interface for entering, browsing and filtering packaged-food records.'
Add-Bullet 'To compute a nutritional risk label from sugar, sodium, fat and additive-level inputs.'
Add-Bullet 'To explain the result through visible nutrient values and an understandable risk message.'
Add-Bullet 'To demonstrate component-based frontend development, REST-oriented service design and data management.'
Add-Bullet 'To validate expected behaviour through functional, boundary and usability testing.'
Add-Sub '2.3 Project Deliverables'
Add-P 'The deliverables include the responsive NutriGuard web interface, product catalogue workflow, risk-classification logic, backend service design, authentication module, test cases and this technical report.' 'both' 22 $false 0 0 390

# 9 Lit
Add-Break; Add-Heading 'CHAPTER 3  LITERATURE SURVEY AND FEASIBILITY'; Add-Sub '3.1 Existing Approach'
Add-P 'Most food information is presented as separate numerical fields on labels or e-commerce listings. While this data is useful, it requires consumers to know appropriate limits and to compare several variables together. Broad nutrition-grade systems also vary by market and often do not expose the specific reason behind a result. A project-level solution benefits from a smaller, explainable ruleset that can be inspected and refined.' 'both' 22 $false 0 130 390
Add-Sub '3.2 Proposed Approach'
Add-P 'NutriGuard combines a structured product record with deterministic classification rules. The rules are evaluated immediately when a record is displayed or submitted. This approach keeps the result consistent, makes the decision explainable and allows the threshold values to be maintained centrally.' 'both' 22 $false 0 130 390
Add-Sub '3.3 Feasibility'
Add-Table @(@('Type','Observation'),@('Technical','React, Spring Boot, Flask and relational persistence provide a practical modular stack.'),@('Operational','The workflow uses familiar search, filters, cards and data-entry forms.'),@('Economic','The open-source development stack keeps prototype implementation costs low.'),@('Schedule','The system can be implemented incrementally: interface, rules, API, validation and tests.')) @(1500,5250)

# 10 req method
Add-Break; Add-Heading 'CHAPTER 4  REQUIREMENTS AND METHODOLOGY'; Add-Sub '4.1 Functional Requirements'
Add-Table @(@('ID','Requirement'),@('FR1','Search products by name and filter by category.'),@('FR2','Display sugar, sodium, fat, additives and the calculated risk label.'),@('FR3','Create a product record after validating mandatory nutrition fields.'),@('FR4','Update or delete an existing food record.'),@('FR5','Protect authorised service access using token-based authentication.')) @(900,5850)
Add-Sub '4.2 Non-functional Requirements'
Add-P 'The application should be responsive, readable, easy to navigate and capable of providing an immediate classification. Inputs should be validated, service endpoints should use structured JSON payloads, and the risk decision should remain deterministic for the same product data.' 'both' 22 $false 0 110 390
Add-Sub '4.3 Development Methodology'
Add-P 'An iterative approach was adopted. Requirements were first translated into user flows, followed by component-based interface development. The rules engine was implemented independently so that its behaviour could be tested at boundary values. Backend and authentication modules were structured as independent services, enabling the product catalogue, persistence and protected access concerns to evolve without changing the user experience.' 'both' 22 $false 0 0 390

# 11 architecture
Add-Break; Add-Heading 'CHAPTER 5  SYSTEM DESIGN AND ARCHITECTURE'; Add-Sub '5.1 Logical Architecture'
Add-P 'The design follows a layered architecture. The presentation layer collects input and displays results. The application layer validates inputs and applies classification rules. The service layer exposes product operations using REST endpoints. The persistence layer stores product entities and supports retrieval. A separate authentication service issues time-limited access tokens for protected operations.' 'both' 22 $false 0 150 390
Add-Table @(@('Layer','Main Responsibility','Technology'),@('Presentation','Catalogue, form, filters and risk display','React 18, Vite, CSS'),@('Application','Risk classification and client-side validation','JavaScript modules'),@('Service','Product REST operations and validation','Spring Boot, Spring Web'),@('Persistence','Product entity storage and query support','Spring Data JPA, H2'),@('Security','Registration, login and protected access','Flask, JWT')) @(1450,3050,2250)
Add-Sub '5.2 Data Flow'
Add-P 'A user searches for a product or submits its nutrition details. The interface validates the required fields and passes a structured food record to the classification module. The module evaluates nutrient thresholds and returns a risk level and reason. The resulting record is shown to the user and can be persisted through the product service. Filters re-evaluate only the visible records, preserving a fast catalogue experience.' 'both' 22 $false 0 0 390

# 12 implementation
Add-Break; Add-Heading 'CHAPTER 6  IMPLEMENTATION DETAILS'; Add-Sub '6.1 Frontend Implementation'
Add-P 'The frontend is built using React 18 and Vite. The application is organised into reusable components for the header, filter bar, product grid and product card. A context module manages food records and exposes create, update and delete actions to the user interface. This separation keeps the screen layout independent from the state-management logic.' 'both' 22 $false 0 120 390
Add-Sub '6.2 Product Workflow'
Add-P 'The user can search by food name, select a category and optionally view only Low Risk products. The risk assessment form captures food name, category, sugar, sodium, fat, serving size and additive level. On submission, mandatory fields are checked and the derived risk label is calculated automatically. The product card displays the category, nutrient details, result and edit/delete actions.' 'both' 22 $false 0 120 390
Add-Sub '6.3 Service and Security Modules'
Add-P 'The Spring Boot service defines a FoodProduct entity, repository and controller to expose product data through REST-oriented endpoints. Spring Data JPA abstracts common persistence operations. A Flask module implements registration and login endpoints using password hashing; successful login returns a JSON Web Token with an expiry period, and a protected dashboard endpoint validates the bearer token.' 'both' 22 $false 0 0 390

# 13 risk model
Add-Break; Add-Heading 'CHAPTER 7  RISK CLASSIFICATION MODEL'; Add-Sub '7.1 Rule Definition'
Add-P 'The rule engine follows a precautionary, explainable approach. Each input is treated as a value per declared serving. A high value in any primary factor is sufficient to mark the product as High Risk. If no high-risk condition is met but one or more monitored values are present, the result is Moderate Risk. Otherwise, the product is Low Risk.' 'both' 22 $false 0 120 390
Add-Table @(@('Risk Level','Decision Rule'),@('High Risk','Sugar > 12 g OR sodium > 450 mg OR fat > 20 g OR additives = High'),@('Moderate Risk','Sugar > 6 g OR sodium > 300 mg OR fat > 12 g OR additives = Medium'),@('Low Risk','All values remain within the basic limits and additives are Low')) @(1800,4950)
Add-Sub '7.2 Algorithm'
Add-P 'Step 1: read nutrient and additive inputs. Step 2: check high-risk conditions. If any condition is true, return High Risk. Step 3: if not high risk, check moderate-risk conditions. If any condition is true, return Moderate Risk. Step 4: otherwise return Low Risk. Step 5: display the result with the corresponding explanation.' 'both' 22 $false 0 120 390
Add-Sub '7.3 Rationale'
Add-P 'The model is intentionally deterministic rather than opaque. This enables a reviewer or user to trace a classification to visible conditions. The thresholds are maintained in one rule module so that they can be revised after expert review without altering the screen components or database schema.' 'both' 22 $false 0 0 390

# 14 Testing
Add-Break; Add-Heading 'CHAPTER 8  TESTING AND RESULTS'; Add-Sub '8.1 Test Cases'
Add-Table @(@('Test ID','Input / Action','Expected Result','Status'),@('TC1','Search “Cream Biscuits”','Matching product is displayed','Pass'),@('TC2','Filter category “Beverage”','Only beverage records are displayed','Pass'),@('TC3','Submit empty food name','Validation message is displayed','Pass'),@('TC4','Sugar 14 g, sodium 380 mg','High Risk is returned due to sugar','Pass'),@('TC5','Sugar 5 g, sodium 240 mg, fat 8 g, Low additives','Low Risk is returned','Pass'),@('TC6','Edit a product nutrient value','Updated label is recalculated','Pass'),@('TC7','Access protected route without token','401 response is returned','Pass')) @(800,2500,2850,800)
Add-Sub '8.2 Observed Results'
Add-P 'The test scenarios confirm that the catalogue can be filtered and that the form prevents incomplete submissions. Boundary-sensitive inputs are evaluated by the same rule module used for display, so the result remains consistent across product cards and new records. The authentication module rejects requests that do not carry a valid bearer token. These outcomes demonstrate the intended end-to-end behaviour of the MVP.' 'both' 22 $false 0 0 390

# 15 conclusion
Add-Break; Add-Heading 'CHAPTER 9  CONCLUSION AND FUTURE SCOPE'; Add-Sub '9.1 Conclusion'
Add-P 'NutriGuard demonstrates a practical way to transform packaged-food nutrition details into a simple, explainable risk indication. The system combines a responsive user interface, structured product records, reusable frontend components, rule-based classification, backend service design and token-based authentication. It meets the core objective of making sugar, sodium, fat and additive information easier to interpret during product selection.' 'both' 22 $false 0 150 390
Add-Sub '9.2 Future Scope'
Add-Bullet 'Integrate a verified external food-data source and barcode scanner for faster product identification.'
Add-Bullet 'Use a production database with user profiles, saved comparisons and audit history.'
Add-Bullet 'Add personalised dietary preferences, allergy information and age-group guidance.'
Add-Bullet 'Support multilingual labels and accessibility features for broader consumer reach.'
Add-Bullet 'Validate and calibrate thresholds with nutrition professionals and published standards.'

# 16 refs
Add-Break; Add-Heading 'REFERENCES'; Add-Blank 1
Add-P '[1] React Documentation. “React: The library for web and native user interfaces.” Available: https://react.dev/. Accessed for project implementation.' 'both' 22 $false 0 100 360
Add-P '[2] Vite Documentation. “Next Generation Frontend Tooling.” Available: https://vite.dev/. Accessed for project implementation.' 'both' 22 $false 0 100 360
Add-P '[3] Spring. “Spring Boot Reference Documentation.” Available: https://docs.spring.io/spring-boot/. Accessed for service-layer design.' 'both' 22 $false 0 100 360
Add-P '[4] Spring. “Spring Data JPA.” Available: https://spring.io/projects/spring-data-jpa. Accessed for persistence-layer design.' 'both' 22 $false 0 100 360
Add-P '[5] Flask Documentation. “Flask Web Development Framework.” Available: https://flask.palletsprojects.com/. Accessed for authentication-module design.' 'both' 22 $false 0 100 360
Add-P '[6] RFC 7519. “JSON Web Token (JWT).” Internet Engineering Task Force, May 2015.' 'both' 22 $false 0 100 360
Add-P '[7] World Health Organization. “Healthy diet.” Available: https://www.who.int/news-room/fact-sheets/detail/healthy-diet. Accessed for health-context review.' 'both' 22 $false 0 100 360
Add-P '[8] NutriGuard Project Source Code. React frontend, Spring Boot API and Flask authentication module, 2026.' 'both' 22 $false 0 0 360

# Rebuild the body in the exact chapter sequence of the supplied WMD template.
$body = New-Object System.Text.StringBuilder
# Page 1: cover
Add-Blank 4; Add-P 'DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING' 'center' 26 $true 50 20 300; Add-P '(ARTIFICIAL INTELLIGENCE AND MACHINE LEARNING)' 'center' 22 $true 0 260 300
Add-P 'NUTRIGUARD' 'center' 40 $true 70 40 360; Add-P 'A Nutritional Risk Classification System for Packaged Foods' 'center' 24 $true 0 260 300
Add-P 'REPORT' 'center' 30 $true 80 220 300; Add-P 'Academic Year: 2026–27' 'center' 22 $true 0 180 300
Add-P 'Topic:' 'center' 20 $true 30 20 300; Add-P '24106190 - Aakshat Mukkawar' 'center' 24 $true 0 300 300
Add-P 'Under the guidance of' 'center' 20 $false 40 20 300; Add-P 'Prof. Vijesh Mundokalam' 'center' 24 $true 0 0 300
# Page 2: toc
Add-Break; Add-Heading 'TABLE OF CONTENTS'; Add-Blank 1
Add-Table @(@('Chapter','Title','Page'),@('1','Introduction','3'),@('2','Problem Statement','5'),@('3','Technology and Tools','7'),@('4','Implementation','9'),@('5','Conclusion and Future Scope','14'),@('6','Sustainable Development Goals Mapping','15'),@('7','References','16')) @(1000,5000,800)
# Page 3: ch1
Add-Break; Add-Heading 'CHAPTER 1: INTRODUCTION'; Add-Sub '➢ Introduction:'
Add-P 'NutriGuard is a web-based nutritional risk classification system developed to make packaged-food nutrition information easier to understand. Consumers are commonly presented with sugar, sodium, fat and additive details as separate values, while the task of deciding whether a product should be consumed regularly is left to them. NutriGuard brings these details together and produces a clear, explainable product-level health score and risk label.' 'both' 22 $false 0 130 390
Add-P 'The application accepts a product name or nutrition profile, retrieves the corresponding information from the product catalogue and displays a simple score based on sugar, sodium, fat and additives. The result is expressed as Low Risk, Moderate Risk or High Risk so that a consumer can make a quicker, better-informed choice. The product is intended as an awareness and comparison tool; it does not replace professional dietary or medical advice.' 'both' 22 $false 0 130 390
Add-P 'The project demonstrates end-to-end web application development through a responsive React interface, a rule-based evaluation module, a product-service layer and secure user authentication. It is aligned with SDG 3, Good Health and Well-being, by promoting informed food choices.' 'both' 22 $false 0 0 390
# Page 4: ch1 features
Add-Break; Add-Heading 'CHAPTER 1: INTRODUCTION'; Add-Sub '➢ Key Features and Scope:'
Add-Bullet 'Search a packaged food by name and view its nutrition profile.'; Add-Bullet 'Display sugar, sodium, fat and additive information in a single readable result view.'; Add-Bullet 'Calculate a transparent health score and risk label using defined rules.'; Add-Bullet 'Offer quick sample searches to make the system easy to explore.'; Add-Bullet 'Support a maintainable product catalogue and a service-ready backend architecture.'
Add-Sub '➢ Intended Users:'; Add-P 'The primary users are consumers who want a quick, simple indication of the nutritional risk associated with packaged food products. The system can also be useful for students, educators and health-awareness campaigns that require an understandable demonstration of nutrition-data interpretation.' 'both' 22 $false 0 100 390
Add-Sub '➢ Project Scope:'; Add-P 'The present MVP focuses on packaged food lookup and classification. It covers nutrition values per serving and a transparent rule set for classifying products. The system is designed to be extended with barcode scanning, verified catalogue APIs, user accounts and personalised dietary preferences in later releases.' 'both' 22 $false 0 0 390
# p5 ch2
Add-Break; Add-Heading 'CHAPTER 2: PROBLEM STATEMENT'; Add-Sub '➢ Problem Statement:'
Add-P 'Packaged-food labels contain essential nutrition data, yet consumers often find it difficult to interpret or compare the information in a short time. A person may see sugar, sodium and fat values on a package but may not know which combination of values deserves attention. Searching across brands also requires reading multiple labels and doing repeated comparisons manually.' 'both' 22 $false 0 130 390
Add-P 'Therefore, there is a need for a user-friendly web application that can organise product information and convert key nutrition values into a simple, consistent and explainable risk indication. The system should allow a consumer to locate a product quickly, understand the factors that influence its result and compare choices without needing specialist knowledge.' 'both' 22 $false 0 150 390
Add-Sub '➢ Proposed Solution:'; Add-P 'NutriGuard solves this problem through a searchable product catalogue and a rule-based classification engine. When a product is selected, the application presents its nutrient values and assigns a score and risk label. The interface gives a reason for the score, enabling users to understand whether sugar, sodium, fat or additives require greater attention.' 'both' 22 $false 0 0 390
# p6 ch2 objective
Add-Break; Add-Heading 'CHAPTER 2: PROBLEM STATEMENT'; Add-Sub '➢ Objectives:'
Add-Bullet 'To build a responsive web interface for searching packaged food products.'; Add-Bullet 'To provide a readable nutrition profile for every selected product.'; Add-Bullet 'To compute a health score and Low, Moderate or High Risk label using deterministic rules.'; Add-Bullet 'To explain the main factors contributing to the displayed result.'; Add-Bullet 'To demonstrate component-based frontend development, backend service design and authentication.'
Add-Sub '➢ Functional Requirements:'; Add-P 'The application shall accept a product search query, retrieve a matching product profile, show nutrition values per serving and produce the appropriate classification. It shall show a clear empty state when no product has been selected and shall make sample product searches available to guide first-time users.' 'both' 22 $false 0 100 390
Add-Sub '➢ Non-functional Requirements:'; Add-P 'The system should be responsive, visually simple, quick to evaluate and easy to use on common screen sizes. The classification must be reproducible for the same data. The interface should provide clear labels, readable contrast and concise messages.' 'both' 22 $false 0 0 390
# p7 ch3 tools
Add-Break; Add-Heading 'CHAPTER 3: TECHNOLOGY AND TOOLS'; Add-Sub '➢ Tools and Methodologies:'
Add-Table @(@('Technology / Tool','Purpose in NutriGuard'),@('React 18','Component-based frontend for the search, result and instruction views.'),@('Vite','Fast development and production build tooling for the web interface.'),@('JavaScript and CSS','State handling, rule execution and responsive visual design.'),@('Spring Boot','REST-oriented backend service for product records.'),@('Spring Data JPA and H2','Entity persistence and repository operations during development.'),@('Flask and PyJWT','Registration, login and token validation for protected access.'),@('Git and VS Code','Version control and source-code development environment.')) @(2500,4300)
# p8 ch3 methodology
Add-Break; Add-Heading 'CHAPTER 3: TECHNOLOGY AND TOOLS'; Add-Sub '➢ Development Methodology:'
Add-P 'The project follows an iterative MVP methodology. First, the user journey was defined as Search, Product Lookup and Health Score. Next, a responsive result screen was developed so users can see the product image, product name, nutrient values, score and explanation together. The rule engine was kept separate from the interface so that risk thresholds can be maintained without redesigning the application.' 'both' 22 $false 0 130 390
Add-Sub '➢ System Architecture:'
Add-Table @(@('Layer','Responsibility'),@('Presentation layer','Captures the search query and presents product information, score and explanation.'),@('Classification layer','Evaluates sugar, sodium, fat and additive values against defined conditions.'),@('Product service layer','Provides product records through REST-oriented endpoints.'),@('Persistence layer','Stores food-product entities and supports retrieval operations.'),@('Security layer','Handles registration, password verification and JWT-protected requests.')) @(2200,4600)
Add-P 'This layered design keeps the user interface, business rules, persistence and access control independently maintainable.' 'both' 22 $false 0 0 390
# p9 impl
Add-Break; Add-Heading 'CHAPTER 4: IMPLEMENTATION'; Add-Sub '➢ Implementation and Source Code:'
Add-P 'The NutriGuard landing screen introduces the purpose of the product in one statement: “Know what is inside your packaged food.” It provides a prominent search control and sample product buttons such as Cream Biscuits, Fruit Drink, Instant Noodles and Oat Snack. This makes the primary interaction clear before a user needs to learn any product-specific workflow.' 'both' 22 $false 0 120 390
Add-Sub '➢ Search Workflow:'; Add-P 'The user enters a product name and selects Check Health Score. The application then retrieves the appropriate nutrition profile, displays the product category and presents the health score. If no product is selected, a clear empty-state message guides the user to search for a sample product. This prevents a blank or confusing result area.' 'both' 22 $false 0 120 390
Add-Sub '➢ Interface Components:'; Add-P 'The interface is divided into a header, hero/search section, product information panel, score panel and a three-step guidance section. The React implementation keeps these responsibilities modular so that components remain reusable and easy to test.' 'both' 22 $false 0 0 390
# p10
Add-Break; Add-Heading 'CHAPTER 4: IMPLEMENTATION'; Add-Sub '➢ Product Lookup and Result Presentation:'
Add-P 'After a successful lookup, NutriGuard displays the selected product with its category and nutrition values per serving. The result panel gives equal visual importance to the score and the reason behind it. The score is represented out of 100 and is paired with a readable risk tag, allowing users to interpret the outcome without reading complex calculations.' 'both' 22 $false 0 130 390
Add-P 'For example, a product with higher sugar, sodium, fat or additive values can receive a lower score and a High Risk classification. Products with values within the basic limits receive a higher score and Low Risk classification. A Moderate Risk state is used where values should be consumed in moderation. This supports a balanced presentation rather than a binary good-or-bad judgement.' 'both' 22 $false 0 120 390
Add-Sub '➢ Result Explanation:'; Add-P 'The “Why this score?” section converts the rule output into a short user-facing explanation. It identifies the key nutrition factors that require attention and explicitly mentions the detected additive level. This explainability is a key part of the design because it connects the visible data to the final label.' 'both' 22 $false 0 0 390
# p11 rules
Add-Break; Add-Heading 'CHAPTER 4: IMPLEMENTATION'; Add-Sub '➢ Rule Based Health Score:'
Add-P 'The classification logic evaluates the nutrient values supplied for a product. The rules are intentionally deterministic, which means the same input always produces the same result. This makes the system easy to test and allows the result to be explained to the user.' 'both' 22 $false 0 100 390
Add-Table @(@('Risk Level','Rule Applied'),@('High Risk','Sugar > 12 g OR Sodium > 450 mg OR Fat > 20 g OR additive level is High.'),@('Moderate Risk','Sugar > 6 g OR Sodium > 300 mg OR Fat > 12 g OR additive level is Medium.'),@('Low Risk','Values remain within the basic limits and additive level is Low.')) @(1700,5100)
Add-Sub '➢ Classification Algorithm:'; Add-P 'Step 1: accept nutrition values. Step 2: check High Risk conditions. Step 3: if no high condition is met, check Moderate Risk conditions. Step 4: otherwise assign Low Risk. Step 5: map the risk result to a score band, colour and user-facing explanation. The final result is rendered immediately in the score panel.' 'both' 22 $false 0 0 390
# p12 service
Add-Break; Add-Heading 'CHAPTER 4: IMPLEMENTATION'; Add-Sub '➢ Backend Service and Data Model:'
Add-P 'The project includes a Spring Boot service module for food-product operations. The FoodProduct entity models the information required by the classification system, while the repository layer provides standard storage and retrieval behaviour using Spring Data JPA. The controller layer exposes this data through REST endpoints, allowing the interface to request product data using JSON.' 'both' 22 $false 0 120 390
Add-Table @(@('Field','Description'),@('id','Unique identifier for the product record.'),@('name / title','Consumer-readable product name.'),@('category','Product category such as Beverage, Bakery or Snack.'),@('sugar, sodium, fat','Key nutrient values per declared serving.'),@('additives','Qualitative additive level used by the rules engine.'),@('servingSize','Reference quantity for the displayed nutrition profile.')) @(2100,4700)
Add-P 'This structure can be extended with barcode, brand, ingredient list, source reference and verification-date fields when a production food-data source is connected.' 'both' 22 $false 0 0 390
# p13 auth testing
Add-Break; Add-Heading 'CHAPTER 4: IMPLEMENTATION'; Add-Sub '➢ Authentication and Testing:'
Add-P 'A Flask-based authentication module supports registration and login. Passwords are processed using hashing rather than being stored as plain text. A successful login returns a time-limited JSON Web Token. Protected routes validate the token in the Authorization header, and requests without a valid bearer token receive an appropriate unauthorised response.' 'both' 22 $false 0 110 390
Add-Table @(@('Test Case','Expected Result','Status'),@('Search product by name','Correct product profile is shown.','Pass'),@('Select sample product','Search is populated and result is displayed.','Pass'),@('High nutrient input','High Risk score and explanation are shown.','Pass'),@('Balanced nutrient input','Low Risk score and explanation are shown.','Pass'),@('Empty search','User receives a clear prompt to enter a product.','Pass'),@('Protected API without token','Service returns an unauthorised response.','Pass')) @(2500,3000,800)
Add-P 'The test results confirm that the principal user flow, rule behaviour and access-control workflow operate as intended for the MVP.' 'both' 22 $false 0 0 390
# p14 c5
Add-Break; Add-Heading 'CHAPTER 5: CONCLUSION AND FUTURE SCOPE'; Add-Sub '➢ Learnings from Web and Mobile Application Development Project:'
Add-P 'NutriGuard demonstrates how a real-world awareness problem can be translated into a usable web application. The project required designing a simple user journey, structuring nutrition information, defining transparent business rules and presenting the result in a way that a non-technical user can understand. The work strengthened practical understanding of React component design, frontend state handling, REST-oriented backend design, data modelling and token-based authentication.' 'both' 22 $false 0 130 390
Add-P 'The project also shows the importance of explainability in health-related interfaces. A risk label alone is not enough; the user must be able to see the values and reason that led to it. Keeping the rules independent of the visual components makes the system easier to test, maintain and refine with expert feedback.' 'both' 22 $false 0 130 390
Add-P 'Future scope includes connecting a verified food-data API, barcode scanning, persistent user accounts, saved product comparisons, personalised dietary preferences, multilingual support and validation of classification thresholds with nutrition professionals. These improvements can transform the MVP into a broader consumer health-information platform.' 'both' 22 $false 0 0 390
# p15 SDG
Add-Break; Add-Heading 'CHAPTER 6: SUSTAINABLE DEVELOPMENT GOALS (SDG) MAPPING'; Add-Sub '➢ SDG Goal 3: Good Health and Well-being'
Add-P 'NutriGuard maps directly to Sustainable Development Goal 3, which aims to ensure healthy lives and promote well-being for all at all ages. Many lifestyle-related health concerns are influenced by long-term dietary choices. By making key packaged-food nutrition details easier to understand, the system encourages users to reflect on sugar, sodium, fat and additive content before purchase or consumption.' 'both' 22 $false 0 130 390
Add-P 'The project supports preventive health awareness rather than medical diagnosis. Its value lies in improving access to understandable information, promoting informed choices and encouraging comparison between products. A scalable version with verified food data and inclusive language support could assist health-awareness initiatives in reaching a wider audience.' 'both' 22 $false 0 130 390
Add-Sub '➢ Contribution of the Project:'; Add-Bullet 'Promotes nutrition awareness at the point of product selection.'; Add-Bullet 'Makes complex label information easier to interpret.'; Add-Bullet 'Encourages healthier choices through transparent, non-judgemental guidance.'; Add-Bullet 'Creates a technical foundation for future public health and consumer education tools.'
# p16 refs
Add-Break; Add-Heading 'CHAPTER 7: REFERENCES'; Add-Blank 1
Add-P '[1] React Documentation. React: The library for web and native user interfaces. https://react.dev/.' 'both' 22 $false 0 110 360; Add-P '[2] Vite Documentation. Next Generation Frontend Tooling. https://vite.dev/.' 'both' 22 $false 0 110 360; Add-P '[3] Spring Boot Reference Documentation. https://docs.spring.io/spring-boot/.' 'both' 22 $false 0 110 360; Add-P '[4] Spring Data JPA. https://spring.io/projects/spring-data-jpa.' 'both' 22 $false 0 110 360; Add-P '[5] Flask Documentation. https://flask.palletsprojects.com/.' 'both' 22 $false 0 110 360; Add-P '[6] Jones, M. et al. RFC 7519: JSON Web Token (JWT). IETF, 2015.' 'both' 22 $false 0 110 360; Add-P '[7] World Health Organization. Healthy diet fact sheet. https://www.who.int/news-room/fact-sheets/detail/healthy-diet.' 'both' 22 $false 0 110 360; Add-P '[8] NutriGuard Project Source Code: React frontend, Spring Boot service and Flask authentication module, 2026.' 'both' 22 $false 0 0 360

$sect = '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/><w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="2160" w:header="720" w:footer="720" w:gutter="0"/><w:headerReference w:type="default" r:id="rId1"/><w:footerReference w:type="default" r:id="rId2"/></w:sectPr>'
$doc = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><w:body>' + $body.ToString() + $sect + '</w:body></w:document>'
$styles = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:docDefaults><w:rPrDefault><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="22"/><w:szCs w:val="22"/></w:rPr></w:rPrDefault></w:docDefaults></w:styles>'
$header = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:hdr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:p><w:pPr><w:jc w:val="center"/><w:spacing w:after="0"/></w:pPr><w:r><w:rPr><w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman"/><w:sz w:val="18"/><w:b/></w:rPr><w:t>DEPARTMENT OF COMPUTER SCIENCE AND ENGINEERING</w:t><w:br/><w:t>(ARTIFICIAL INTELLIGENCE AND MACHINE LEARNING)</w:t></w:r></w:p></w:hdr>'
$footer = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><w:ftr xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:p><w:pPr><w:jc w:val="center"/></w:pPr><w:r><w:rPr><w:rFonts w:ascii="Times New Roman"/><w:sz w:val="18"/></w:rPr><w:t>Department of Computer Science and Engineering (AI and ML)  |  Page </w:t></w:r><w:r><w:fldChar w:fldCharType="begin"/></w:r><w:r><w:instrText>PAGE</w:instrText></w:r><w:r><w:fldChar w:fldCharType="end"/></w:r></w:p></w:ftr>'
$contentTypes = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types"><Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/><Default Extension="xml" ContentType="application/xml"/><Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/><Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/><Override PartName="/word/header1.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.header+xml"/><Override PartName="/word/footer1.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.footer+xml"/></Types>'
$rootRels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>'
$docRels = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"><Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/header" Target="header1.xml"/><Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/footer" Target="footer1.xml"/><Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>'
$zip=[System.IO.Compression.ZipFile]::Open($out,[System.IO.Compression.ZipArchiveMode]::Create)
function Put([string]$path,[string]$data){$e=$zip.CreateEntry($path);$sw=New-Object System.IO.StreamWriter($e.Open(),[System.Text.Encoding]::UTF8);$sw.Write($data);$sw.Dispose()}
Put '[Content_Types].xml' $contentTypes; Put '_rels/.rels' $rootRels; Put 'word/document.xml' $doc; Put 'word/styles.xml' $styles; Put 'word/header1.xml' $header; Put 'word/footer1.xml' $footer; Put 'word/_rels/document.xml.rels' $docRels
$zip.Dispose(); Write-Output $out

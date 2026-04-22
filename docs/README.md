# InternLink Nepal
**A Trusted Centralized Platform for Internship and Job Placement in Nepal**

---

## Project Structure

```
InternLinkNepal/
├── pom.xml                            ← Maven build config
├── sql/
│   └── schema.sql                     ← Full DB schema + seed data
├── docs/
│   └── README.md                      ← This file
└── src/main/
    ├── java/com/internlink/
    │   ├── dao/                       ← Database Access Objects
    │   │   ├── ApplicationDAO.java
    │   │   ├── CompanyDAO.java
    │   │   ├── JobPostingDAO.java
    │   │   ├── StudentProfileDAO.java
    │   │   └── UserDAO.java
    │   ├── filter/
    │   │   └── AuthFilter.java        ← Role-based route protection
    │   ├── model/                     ← Plain Java model classes
    │   │   ├── Application.java
    │   │   ├── Company.java
    │   │   ├── JobPosting.java
    │   │   ├── StudentProfile.java
    │   │   └── User.java
    │   ├── servlet/
    │   │   ├── HomeServlet.java       ← Landing page
    │   │   ├── auth/
    │   │   │   ├── LoginServlet.java
    │   │   │   ├── LogoutServlet.java
    │   │   │   └── RegisterServlet.java
    │   │   ├── student/
    │   │   │   └── StudentDashboardServlet.java
    │   │   ├── company/
    │   │   │   ├── CompanyDashboardServlet.java
    │   │   │   ├── PostJobServlet.java
    │   │   │   └── UpdateStatusServlet.java
    │   │   └── admin/
    │   │       ├── AdminDashboardServlet.java
    │   │       └── AdminVerifyCompanyServlet.java
    │   └── util/
    │       ├── DBConnection.java      ← JDBC connection helper
    │       ├── PasswordUtil.java      ← BCrypt hashing
    │       └── SessionUtil.java       ← Session management
    └── webapp/
        ├── WEB-INF/
        │   └── web.xml
        ├── assets/
        │   ├── css/main.css           ← All styles
        │   └── js/main.js             ← Carousel, charts, maps, modals
        ├── components/
        │   ├── header.jsp             ← Shared navbar
        │   └── footer.jsp             ← Shared footer
        ├── pages/
        │   ├── home.jsp               ← Landing page (carousel + map)
        │   ├── auth/
        │   │   ├── login.jsp
        │   │   └── register.jsp
        │   ├── student/
        │   │   └── dashboard.jsp
        │   ├── company/
        │   │   ├── dashboard.jsp      ← Worker details + charts + map
        │   │   └── postJob.jsp
        │   ├── admin/
        │   │   └── dashboard.jsp
        │   └── error/
        │       ├── 404.jsp
        │       └── 500.jsp
        └── index.jsp                  ← Forwards to HomeServlet
```

---

## Setup Instructions

### 1. Prerequisites
- **Java 11+**
- **Apache Tomcat 10.x**
- **MySQL 8.x**
- **Maven 3.8+**
- **IDE**: IntelliJ IDEA or Eclipse (recommended)

---

### 2. Database Setup
```sql
-- Open MySQL Workbench or terminal and run:
mysql -u root -p < sql/schema.sql
```
This creates the `internlink_nepal` database, all tables, and sample data.

---

### 3. Configure DB Connection
Edit `src/main/java/com/internlink/util/DBConnection.java`:
```java
private static final String DB_URL  = "jdbc:mysql://localhost:3306/internlink_nepal?useSSL=false&serverTimezone=UTC";
private static final String DB_USER = "root";
private static final String DB_PASS = "YOUR_MYSQL_PASSWORD";  // ← Change this
```

---

### 4. Build & Deploy
```bash
# Build WAR file
mvn clean package

# Deploy to Tomcat
cp target/InternLinkNepal.war /path/to/tomcat/webapps/

# Start Tomcat
/path/to/tomcat/bin/startup.sh
```

Then open: **http://localhost:8080/InternLinkNepal/**

---

### 5. Demo Accounts
All demo accounts use password: `Admin@123`

| Role    | Email                        |
|---------|------------------------------|
| Admin   | admin@internlink.com.np      |
| Company | leapfrog@demo.com            |
| Company | cloudFactory@demo.com        |
| Student | ram@demo.com                 |
| Student | sita@demo.com                |

---

## Key Features

### Landing Page
- Hero section with search bar
- **Carousel** with 3 slides (SVG-based, no external images needed)
- Stats strip (students, companies, placements)
- Live job listings from DB
- **OpenStreetMap** (Leaflet.js) showing verified company locations — **free, no API key required**
- Role cards (Student / Company / Admin)

### Student Dashboard
- Application tracking with status badges
- Profile completeness meter
- Smart job recommendations (skill-based)
- Recent applications table

### Company Dashboard
- **Applicant breakdown**: Fresher / Intern / Experienced with donut chart
- **Application pipeline** bar chart
- Filter applicants by experience type and status
- Update application status via modal
- Company location on **Leaflet/OpenStreetMap**
- Post new jobs

### Admin Dashboard
- Platform-wide metrics
- Company verification workflow (Verify / Revoke)
- Student breakdown by experience type
- All companies and job posts overview

---

## Maps — Free, No API Key Required
This project uses **Leaflet.js + OpenStreetMap** (100% free).
- Company locations are stored as latitude/longitude in the DB
- The register form has an **auto-geocode button** that uses the free **Nominatim API** to convert an address to lat/lng
- No Google Maps API key is needed

If you prefer Google Maps, replace the Leaflet section in JSP files with:
```html
<script src="https://maps.googleapis.com/maps/api/js?key=YOUR_KEY&callback=initMap" async></script>
```

---

## Technology Stack

| Layer      | Technology                        |
|------------|-----------------------------------|
| Backend    | Java 11, Servlet API 5, JSP 3     |
| Database   | MySQL 8 + JDBC                    |
| Frontend   | HTML5, CSS3, Vanilla JS           |
| Maps       | Leaflet.js + OpenStreetMap (free) |
| Security   | BCrypt (jBCrypt), Session auth    |
| Build      | Apache Maven                      |
| Server     | Apache Tomcat 10                  |

---

## Adding New Features
- **New servlet**: Create in appropriate package under `servlet/`, annotate with `@WebServlet`
- **New page**: Add JSP under `pages/`, include `header.jsp` and `footer.jsp`
- **New DB table**: Add to `sql/schema.sql` and create matching DAO + Model
- **New route protection**: Update `AuthFilter.java` URL patterns

---

## Common Issues

| Issue | Fix |
|-------|-----|
| 404 on deploy | Check Tomcat context path; ensure WAR name matches URL |
| DB connection failed | Verify MySQL is running and credentials in `DBConnection.java` |
| JSTL tags not resolving | Ensure `jakarta.servlet.jsp.jstl` dependency in `pom.xml` |
| Session not persisting | Check Tomcat session config in `web.xml` |

---

*InternLink Nepal — Bridging academia and industry for Nepali bachelor students.*

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Create Account – InternLink Nepal"/>
<jsp:include page="/components/header.jsp"/>

<div style="min-height:calc(100vh - 60px);background:var(--gray-50);padding:40px 16px;">
  <div style="max-width:620px;margin:0 auto;">

    <div style="text-align:center;margin-bottom:28px;">
      <h1 style="font-size:26px;font-weight:700;">Create Your Account</h1>
      <p style="color:var(--text-secondary);font-size:14px;margin-top:4px;">Join thousands of students and companies on InternLink Nepal</p>
    </div>

    <c:if test="${not empty error}">
      <div class="alert alert-error" data-auto-dismiss>&#9888; ${error}</div>
    </c:if>

    <!-- Role Tabs -->
    <div style="display:flex;border-radius:var(--radius-md);overflow:hidden;border:1.5px solid var(--border);margin-bottom:24px;background:#fff;">
      <button onclick="switchRole('STUDENT')" id="tab-STUDENT"
        style="flex:1;padding:12px;border:none;font-size:14px;font-weight:600;cursor:pointer;background:var(--primary);color:#fff;">
        &#127891; I am a Student
      </button>
      <button onclick="switchRole('COMPANY')" id="tab-COMPANY"
        style="flex:1;padding:12px;border:none;font-size:14px;font-weight:600;cursor:pointer;background:#fff;color:var(--text-secondary);">
        &#127970; I am a Company
      </button>
    </div>

    <div class="card">
      <div class="card-body" style="padding:32px;">
        <form action="${pageContext.request.contextPath}/register" method="post" id="regForm">
          <input type="hidden" name="role" id="roleField" value="STUDENT"/>

          <!-- Common fields -->
          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Email Address *</label>
              <input type="email" name="email" class="form-control" placeholder="your@email.com" required/>
            </div>
            <div class="form-group">
              <label class="form-label">Phone Number</label>
              <input type="text" name="phone" class="form-control" placeholder="98XXXXXXXX"/>
            </div>
          </div>
          <div class="grid-2">
            <div class="form-group">
              <label class="form-label">Password *</label>
              <input type="password" name="password" class="form-control" placeholder="Min 8 characters" required minlength="8"/>
            </div>
            <div class="form-group">
              <label class="form-label">Confirm Password *</label>
              <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter password" required/>
            </div>
          </div>

          <!-- STUDENT FIELDS -->
          <div id="studentFields">
            <hr style="border:none;border-top:1px solid var(--border);margin:8px 0 20px;"/>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">Full Name *</label>
                <input type="text" name="fullName" class="form-control" placeholder="Ram Sharma"/>
              </div>
              <div class="form-group">
                <label class="form-label">University *</label>
                <input type="text" name="university" class="form-control" placeholder="Tribhuvan University"/>
              </div>
            </div>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">Program</label>
                <input type="text" name="program" class="form-control" placeholder="BIT / BCA / BE CS"/>
              </div>
              <div class="form-group">
                <label class="form-label">Current Semester</label>
                <select name="semester" class="form-control">
                  <c:forEach begin="1" end="8" var="s">
                    <option value="${s}">Semester ${s}</option>
                  </c:forEach>
                </select>
              </div>
            </div>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">CGPA</label>
                <input type="number" name="cgpa" class="form-control" placeholder="3.50" step="0.01" min="0" max="4"/>
              </div>
              <div class="form-group">
                <label class="form-label">Skills (comma-separated)</label>
                <input type="text" name="skills" class="form-control" placeholder="Java, MySQL, React"/>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Brief Bio</label>
              <textarea name="bio" class="form-control" rows="3" placeholder="Tell companies about yourself…"></textarea>
            </div>
          </div>

          <!-- COMPANY FIELDS -->
          <div id="companyFields" style="display:none;">
            <hr style="border:none;border-top:1px solid var(--border);margin:8px 0 20px;"/>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">Company Name *</label>
                <input type="text" name="companyName" class="form-control" placeholder="Leapfrog Technology"/>
              </div>
              <div class="form-group">
                <label class="form-label">Industry</label>
                <input type="text" name="industry" class="form-control" placeholder="Software Development"/>
              </div>
            </div>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">Website</label>
                <input type="url" name="website" class="form-control" placeholder="https://yourcompany.com"/>
              </div>
              <div class="form-group">
                <label class="form-label">Founded Year</label>
                <input type="number" name="foundedYear" class="form-control" placeholder="2015"/>
              </div>
            </div>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">City *</label>
                <input type="text" name="city" class="form-control" placeholder="Kathmandu"/>
              </div>
              <div class="form-group">
                <label class="form-label">Employee Count</label>
                <select name="employeeCount" class="form-control">
                  <option>1-10</option><option>10-50</option>
                  <option>50-200</option><option>200-500</option><option>500+</option>
                </select>
              </div>
            </div>
            <div class="form-group">
              <label class="form-label">Full Address</label>
              <input type="text" name="address" id="address" class="form-control" placeholder="Street, Area, City"/>
            </div>
            <div class="grid-2">
              <div class="form-group">
                <label class="form-label">Latitude</label>
                <input type="text" name="latitude" id="latitude" class="form-control" placeholder="27.7172"/>
              </div>
              <div class="form-group">
                <label class="form-label">Longitude</label>
                <input type="text" name="longitude" id="longitude" class="form-control" placeholder="85.3240"/>
              </div>
            </div>
            <button type="button" id="geocodeBtn" class="btn btn-ghost btn-sm" style="margin-bottom:16px;">&#128205; Auto-detect from address</button>
            <div class="form-group">
              <label class="form-label">Company Description</label>
              <textarea name="description" class="form-control" rows="3" placeholder="What does your company do?"></textarea>
            </div>
          </div>

          <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top:12px;">Create Account</button>
        </form>

        <div style="text-align:center;margin-top:20px;font-size:13px;color:var(--text-secondary);">
          Already have an account?
          <a href="${pageContext.request.contextPath}/login" style="color:var(--primary);font-weight:600;">Sign in</a>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
function switchRole(role) {
  document.getElementById('roleField').value = role;
  document.getElementById('studentFields').style.display = role === 'STUDENT' ? '' : 'none';
  document.getElementById('companyFields').style.display = role === 'COMPANY' ? '' : 'none';
  document.getElementById('tab-STUDENT').style.background = role === 'STUDENT' ? 'var(--primary)' : '#fff';
  document.getElementById('tab-STUDENT').style.color      = role === 'STUDENT' ? '#fff' : 'var(--text-secondary)';
  document.getElementById('tab-COMPANY').style.background = role === 'COMPANY' ? 'var(--primary)' : '#fff';
  document.getElementById('tab-COMPANY').style.color      = role === 'COMPANY' ? '#fff' : 'var(--text-secondary)';
}
// Pre-select role from URL param
const urlRole = new URLSearchParams(location.search).get('role');
if (urlRole === 'COMPANY') switchRole('COMPANY');
</script>

<jsp:include page="/components/footer.jsp"/>

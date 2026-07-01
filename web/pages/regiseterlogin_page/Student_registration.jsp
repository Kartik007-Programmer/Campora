<%-- 
    Document   : Student_registration_1
    Created on : Aug 4, 2025, 2:16:11 PM
    Author     : Batch4
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="mypackage.DAO" %>
<%@ page import="mypackage.Course" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  <title>Corona Admin</title>
  <link rel="stylesheet" href="../../assets/vendors/mdi/css/materialdesignicons.min.css">
  <link rel="stylesheet" href="../../assets/vendors/css/vendor.bundle.base.css">
  <link rel="stylesheet" href="../../assets/css/style.css">
  <link rel="shortcut icon" href="../../assets/images/favicon.png" />
</head>
<%
    try {
        DAO courseDAO = new DAO();
        List<Course> courses = courseDAO.getAllCourses();
        request.setAttribute("courses", courses);
    } catch (SQLException e) {
        request.setAttribute("error", "Database error: " + e.getMessage());
    }
%>

<%
    // Get the parameter from URL
    String selectedCourse = request.getParameter("StudentCourse");
%>
<body>

    <style>
        /* 🌙 Dark Theme Styles for Form Controls */
body {
  background-color: #121212;
  color: #e0e0e0;
}

.form-control {
  background-color: #1e1e1e;
  color: #f5f5f5;
  border: 1px solid #333;
  border-radius: 6px;
  padding: 10px 12px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.form-control:focus {
  background-color: #252525;
  color: #fff;
  border-color: #3f51b5;
  box-shadow: 0 0 0 3px rgba(63, 81, 181, 0.4);
  outline: none;
}

.form-control::placeholder {
  color: #aaaaaa;
  opacity: 1;
}



label {
  color: #d1d1d1;
  font-weight: 500;
}

.btn {
  border-radius: 6px;
  padding: 10px 16px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.btn-primary {
  background-color: #3f51b5;
  border: none;
  color: #fff;
}

.btn-primary:hover {
  background-color: #5c6bc0;
}

.btn-secondary {
  background-color: #444;
  border: none;
  color: #f5f5f5;
}

.btn-secondary:hover {
  background-color: #555;
}
    </style>
        
    
<c:if test="${not empty error}">
  <script>alert("${error}");</script>
</c:if>
  <div class="container-scroller">
    <div class="container-fluid page-body-wrapper full-page-wrapper">
      <div class="row w-100 m-0">
        <div class="content-wrapper full-page-wrapper d-flex align-items-center auth login-bg">
          <div class="card col-lg-8 mx-auto">
            <div class="card-body px-5 py-5">
              <p class="card-description"> Apply for CAMPORA 2025 </p>
              <h3 class="card-title text-left mb-3">Registration</h3>

            <form class="form-group" method="post" action="<%= request.getContextPath() %>/StudentServlet" enctype="multipart/form-data">
                <!-- Upload -->
                <div class="form-group">
                  <label>Student Photo</label>
                  <input type="file" name="StudentPhoto" class="file-upload-default" accept=".jpg,.png,.svg,.jpeg" multiple style="display:none" id="fileInput">
                  <div class="input-group">
                    <input type="text" class="form-control file-upload-info" disabled placeholder="Photo size upto 4MB, Only JPG, PNG, JPEG and SVG" style="font-size: 0.8rem;">
                    <span class="input-group-append">
                     <button class="file-upload-browse btn btn-primary" type="button" id="browseButton">Upload</button>
                    </span>
                  </div>
                </div>

                <p class="card-description"> Personal Info </p>
                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Full Name</label>
                      <div class="col-sm-9">
                          <input type="text" class="form-control" placeholder="Full Name" id="FullName" required />
                      </div>
                    </div>
                  </div>

                  <!-- Hidden First Name and Last Name fields -->
                 <input type="hidden" id="FirstName" name="StudentFirstName" />
                 <input type="hidden" id="LastName" name="StudentLastName" />
                 
                  <!-- Email -->
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Email</label>
                      <div class="col-sm-9">
                      <input type="email" class="form-control" placeholder="Your Email Address" name="StudentEmail" required />
                      </div>
                    </div>
                  </div>
                </div>
                <div class="row">
                    
                  <!-- Gender -->
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Gender </label>
                      <div class="col-sm-4">
                        <div class="form-check">
                          <label class="form-check-label">
                          <input type="radio" class="form-check-input" name="StudentGender" value="Male" checked>  Male
                          </label>
                        </div>
                      </div>
                      <div class="col-sm-5">
                        <div class="form-check">
                          <label class="form-check-label">
                          <input type="radio" class="form-check-input" name="StudentGender" value="Female"> Female
                          </label>
                        </div>
                      </div>
                    </div>
                  </div>
                
             <!-- Password -->
                  <div class="col-md-6">
                    <div class="form-group row">
                <label class="col-sm-3 col-form-label">Password</label>
                <div class="col-sm-9">
                    <input type="password" class="form-control" name="StudentPassword"placeholder="Enter Password" required />
                    </div>
                    </div>
                  </div>
                </div>
                
                <!-- NEW ROW: Mobile Number & Email -->
                <div class="row">
                  <!-- Mobile Number -->
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Mobile</label>
                      <div class="col-sm-9">
                      <input type="tel" class="form-control" placeholder="Your Mobile Number" name="StudentMobile" required pattern="[0-9]{10}" />
                      </div>
                    </div>
                  </div>
                
                 
                  <!-- D.O.B -->
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">D.O.B</label>
                      <div class="col-sm-9">
                          <input type="date" class="form-control" name="StudentDOB" required  style="color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'"/>
                      </div>
                    </div>
                  </div>
                </div>
                

                <div class="row">
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Course</label>
                      <div class="col-sm-9">
                          <select class="form-control" name="StudentCourse" style="border: 1px solid #333; color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                              <option disabled selected>Select Your Course</option>
                          <c:forEach var="course" items="${courses}"> 
                              <option value="${course.name}">${course.name}</option>
                          </c:forEach>
                      </select>
                      </div>
                    </div>
                  </div>
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Qualification</label>
                      <div class="col-sm-9 d-flex align-items-center">
                      <select class="form-control mr-2" id="qualificationSelect" name="StudentQualification" required style="width: 70%;border: 1px solid #333;color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'">
                          <option  disabled selected>Your Qualification</option>
                        <option value="percentage">10th / 12th</option>
                        <option value="percentage">Industrial Training Institute</option>
                        <option value="cgpa">Diploma</option>
                        <option value="cgpa">Bachelor</option>
                        <option value="percentage">Others</option>
                      </select>
                      <input type="text" id="gradeInput" name="StudentLYP" class="form-control" min="0" style="width: 30%;" required />
                    </div>
                    </div>
                  </div>
                  
                  <script>
                    const qualificationSelect = document.getElementById('qualificationSelect');
                    const gradeInput = document.getElementById('gradeInput');
                  
                    qualificationSelect.addEventListener('change', function () {
                      const selectedType = this.value;
                  
                      if (selectedType === 'cgpa') {
                        gradeInput.placeholder = "CGPA";
                        gradeInput.step = "0.1";
                        gradeInput.max = "10";
                      } else {
                        gradeInput.placeholder = "%";
                        gradeInput.step = "30";
                        gradeInput.max = "100";
                      }
                  
                      gradeInput.value = ""; // Clear input when switching
                    });
                  </script>
                                     
                </div>
       
                <p class="card-description">Address Details</p>
                <div class="row">
                  <!-- Address 1 spans 8 columns -->
                  <div class="col-md-6">
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">Address</label>
                      <div class="col-sm-9">
                      <textarea name="StudentAddressLine1" placeholder="Flat No, Street, Colony" class="form-control" required rows="3"></textarea>
                      </div>
                    </div>
                
                   <!-- Address 2 -->
                  <div class="form-group row">
                   <label class="col-sm-3 col-form-label">Address 2</label>
                  <div class="col-sm-9">
                      <input type="text" name="StudentAddressLine2" class="form-control" placeholder="Street Address, Area, Road" required />
                  </div>
                </div>    
                
                <!-- City -->
                    <div class="form-group row">
                      <label class="col-sm-3 col-form-label">City</label>
                      <div class="col-sm-9">
                          <select class="form-control" id="City" name="StudentCity" style="border: 1px solid #333;color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                          <option disabled selected>Select Your City</option>
                        </select>
                      </div>
                    </div>
                  </div>

                <!-- Right Column: Postcode, Landmark, State -->
              <div class="col-md-6">
                <!-- Postcode -->
                <div class="form-group row">
                 <label class="col-sm-3 col-form-label">Postcode</label>
                <div class="col-sm-9">
                      <input type="text" name="StudentPincode" class="form-control" required " placeholder="Enter 6-digit Pincode" />
                </div>
             </div>

              <!-- Landmark (moved here) -->
               <div class="form-group row">
                 <label class="col-sm-3 col-form-label">Landmark</label>
               <div class="col-sm-9">
                      <input type="text" name="StudentLandmark" class="form-control" required placeholder="Landmark near your address" />
               </div>
            </div>
                
                  <!-- State Selection -->
                  <div class="form-group row">
                      <label class="col-sm-3 col-form-label">State</label>
                      <div class="col-sm-9">
                          <select name="StudentState" id="State" class="form-control" style="border: 1px solid #333;color:#aaaaaa;" onchange="this.style.color = '#f5f5f5'" required>
                          <option disabled selected>Select Your State</option>
                       
                        </select>
                      </div>
                    </div>
                  </div>
                </div>
                
                <!-- Terms & Conditions -->
                <div class="form-group d-flex align-items-center justify-content-between">
                  <div class="form-check">
                    <label class="form-check-label" style="color: white;">
                  <input type="checkbox" class="form-check-input" name="StudentRemember" required>
                      Agree To our Terms & Conditions
                    </label>
                  </div> 

                <!-- Sign In Link -->
                <p class="sign-up text-center mt-2">
                  Already have an Account? <a href="LoginForm.jsp">Sign In</a>
                </p>
                
                  <!-- <a href="#" class="forgot-pass">Forgot password?</a> -->
                </div>
                
                <!-- Submit Button -->
                <div class="text-center mt-4">
                  <button type="submit" class="btn btn-primary btn-block enter-btn">Register</button>
                </div>

  <!-- JS -->
  <script>
  document.getElementById("FullName").addEventListener("input", function () {
    const fullName = this.value.trim();
    const parts = fullName.split(/\s+/);

    const firstName = parts[0] || "";
    const lastName = parts.length > 1 ? parts.slice(1).join(" ") : "";

    document.getElementById("FirstName").value = firstName;
    document.getElementById("LastName").value = lastName;
  });
</script>

  <script>
    document.getElementById('browseButton').addEventListener('click', function () {
      document.getElementById('fileInput').click();
    });

    document.getElementById('fileInput').addEventListener('change', function () {
      const files = this.files;
      const fileInfoInput = document.querySelector('.file-upload-info');
      let isValid = true;
      let fileNames = [];

      Array.from(files).forEach(file => {
        if (file.size > 4 * 1024 * 1024) {
          alert("File size exceeds 4MB. Please upload a smaller file.");
          isValid = false;
        }
        const validFormats = ['image/jpeg', 'image/png', 'image/svg+xml'];
        if (!validFormats.includes(file.type)) {
          alert("Invalid file format. Only JPG, PNG, SVG are allowed.");
          isValid = false;
        }
        fileNames.push(file.name);
      });

      if (isValid) {
        fileInfoInput.value = fileNames.join(', ') + " selected";
      }
    });
  </script>
  <script>
    // Indian States and Cities (sample, can be expanded)
    const stateCityData = { "Andaman and Nicobar Islands": [ "Port Blair" ], "Haryana": [ "Faridabad", "Gurgaon", "Hisar", "Rohtak", "Panipat", "Karnal", "Sonipat", "Yamunanagar", "Panchkula", "Bhiwani", "Bahadurgarh", "Jind", "Sirsa", "Thanesar", "Kaithal", "Palwal", "Rewari", "Hansi", "Narnaul", "Fatehabad", "Gohana", "Tohana", "Narwana", "Mandi Dabwali", "Charkhi Dadri", "Shahbad", "Pehowa", "Samalkha", "Pinjore", "Ladwa", "Sohna", "Safidon", "Taraori", "Mahendragarh", "Ratia", "Rania", "Sarsod" ], "Tamil Nadu": [ "Chennai", "Coimbatore", "Madurai", "Tiruchirappalli", "Salem", "Tirunelveli", "Tiruppur", "Ranipet", "Nagercoil", "Thanjavur", "Vellore", "Kancheepuram", "Erode", "Tiruvannamalai", "Pollachi", "Rajapalayam", "Sivakasi", "Pudukkottai", "Neyveli (TS)", "Nagapattinam", "Viluppuram", "Tiruchengode", "Vaniyambadi", "Theni Allinagaram", "Udhagamandalam", "Aruppukkottai", "Paramakudi", "Arakkonam", "Virudhachalam", "Srivilliputhur", "Tindivanam", "Virudhunagar", "Karur", "Valparai", "Sankarankovil", "Tenkasi", "Palani", "Pattukkottai", "Tirupathur", "Ramanathapuram", "Udumalaipettai", "Gobichettipalayam", "Thiruvarur", "Thiruvallur", "Panruti", "Namakkal", "Thirumangalam", "Vikramasingapuram", "Nellikuppam", "Rasipuram", "Tiruttani", "Nandivaram-Guduvancheri", "Periyakulam", "Pernampattu", "Vellakoil", "Sivaganga", "Vadalur", "Rameshwaram", "Tiruvethipuram", "Perambalur", "Usilampatti", "Vedaranyam", "Sathyamangalam", "Puliyankudi", "Nanjikottai", "Thuraiyur", "Sirkali", "Tiruchendur", "Periyasemur", "Sattur", "Vandavasi", "Tharamangalam", "Tirukkoyilur", "Oddanchatram", "Palladam", "Vadakkuvalliyur", "Tirukalukundram", "Uthamapalayam", "Surandai", "Sankari", "Shenkottai", "Vadipatti", "Sholingur", "Tirupathur", "Manachanallur", "Viswanatham", "Polur", "Panagudi", "Uthiramerur", "Thiruthuraipoondi", "Pallapatti", "Ponneri", "Lalgudi", "Natham", "Unnamalaikadai", "P.N.Patti", "Tharangambadi", "Tittakudi", "Pacode", "O' Valley", "Suriyampalayam", "Sholavandan", "Thammampatti", "Namagiripettai", "Peravurani", "Parangipettai", "Pudupattinam", "Pallikonda", "Sivagiri", "Punjaipugalur", "Padmanabhapuram", "Thirupuvanam" ], "Madhya Pradesh": [ "Indore", "Bhopal", "Jabalpur", "Gwalior", "Ujjain", "Sagar", "Ratlam", "Satna", "Murwara (Katni)", "Morena", "Singrauli", "Rewa", "Vidisha", "Ganjbasoda", "Shivpuri", "Mandsaur", "Neemuch", "Nagda", "Itarsi", "Sarni", "Sehore", "Mhow Cantonment", "Seoni", "Balaghat", "Ashok Nagar", "Tikamgarh", "Shahdol", "Pithampur", "Alirajpur", "Mandla", "Sheopur", "Shajapur", "Panna", "Raghogarh-Vijaypur", "Sendhwa", "Sidhi", "Pipariya", "Shujalpur", "Sironj", "Pandhurna", "Nowgong", "Mandideep", "Sihora", "Raisen", "Lahar", "Maihar", "Sanawad", "Sabalgarh", "Umaria", "Porsa", "Narsinghgarh", "Malaj Khand", "Sarangpur", "Mundi", "Nepanagar", "Pasan", "Mahidpur", "Seoni-Malwa", "Rehli", "Manawar", "Rahatgarh", "Panagar", "Wara Seoni", "Tarana", "Sausar", "Rajgarh", "Niwari", "Mauganj", "Manasa", "Nainpur", "Prithvipur", "Sohagpur", "Nowrozabad (Khodargama)", "Shamgarh", "Maharajpur", "Multai", "Pali", "Pachore", "Rau", "Mhowgaon", "Vijaypur", "Narsinghgarh" ], "Jharkhand": [ "Dhanbad", "Ranchi", "Jamshedpur", "Bokaro Steel City", "Deoghar", "Phusro", "Adityapur", "Hazaribag", "Giridih", "Ramgarh", "Jhumri Tilaiya", "Saunda", "Sahibganj", "Medininagar (Daltonganj)", "Chaibasa", "Chatra", "Gumia", "Dumka", "Madhupur", "Chirkunda", "Pakaur", "Simdega", "Musabani", "Mihijam", "Patratu", "Lohardaga", "Tenu dam-cum-Kathhara" ], "Mizoram": [ "Aizawl", "Lunglei", "Saiha" ], "Nagaland": [ "Dimapur", "Kohima", "Zunheboto", "Tuensang", "Wokha", "Mokokchung" ], "Himachal Pradesh": [ "Shimla", "Mandi", "Solan", "Nahan", "Sundarnagar", "Palampur", "Kullu" ], "Tripura": [ "Agartala", "Udaipur", "Dharmanagar", "Pratapgarh", "Kailasahar", "Belonia", "Khowai" ], "Andhra Pradesh": [ "Visakhapatnam", "Vijayawada", "Guntur", "Nellore", "Kurnool", "Rajahmundry", "Kakinada", "Tirupati", "Anantapur", "Kadapa", "Vizianagaram", "Eluru", "Ongole", "Nandyal", "Machilipatnam", "Adoni", "Tenali", "Chittoor", "Hindupur", "Proddatur", "Bhimavaram", "Madanapalle", "Guntakal", "Dharmavaram", "Gudivada", "Srikakulam", "Narasaraopet", "Rajampet", "Tadpatri", "Tadepalligudem", "Chilakaluripet", "Yemmiganur", "Kadiri", "Chirala", "Anakapalle", "Kavali", "Palacole", "Sullurpeta", "Tanuku", "Rayachoti", "Srikalahasti", "Bapatla", "Naidupet", "Nagari", "Gudur", "Vinukonda", "Narasapuram", "Nuzvid", "Markapur", "Ponnur", "Kandukur", "Bobbili", "Rayadurg", "Samalkot", "Jaggaiahpet", "Tuni", "Amalapuram", "Bheemunipatnam", "Venkatagiri", "Sattenapalle", "Pithapuram", "Palasa Kasibugga", "Parvathipuram", "Macherla", "Gooty", "Salur", "Mandapeta", "Jammalamadugu", "Peddapuram", "Punganur", "Nidadavole", "Repalle", "Ramachandrapuram", "Kovvur", "Tiruvuru", "Uravakonda", "Narsipatnam", "Yerraguntla", "Pedana", "Puttur", "Renigunta", "Rajam", "Srisailam Project (Right Flank Colony) Township" ], "Punjab": [ "Ludhiana", "Patiala", "Amritsar", "Jalandhar", "Bathinda", "Pathankot", "Hoshiarpur", "Batala", "Moga", "Malerkotla", "Khanna", "Mohali", "Barnala", "Firozpur", "Phagwara", "Kapurthala", "Zirakpur", "Kot Kapura", "Faridkot", "Muktsar", "Rajpura", "Sangrur", "Fazilka", "Gurdaspur", "Kharar", "Gobindgarh", "Mansa", "Malout", "Nabha", "Tarn Taran", "Jagraon", "Sunam", "Dhuri", "Firozpur Cantt.", "Sirhind Fatehgarh Sahib", "Rupnagar", "Jalandhar Cantt.", "Samana", "Nawanshahr", "Rampura Phul", "Nangal", "Nakodar", "Zira", "Patti", "Raikot", "Longowal", "Urmar Tanda", "Morinda, India", "Phillaur", "Pattran", "Qadian", "Sujanpur", "Mukerian", "Talwara" ], "Chandigarh": [ "Chandigarh" ], "Rajasthan": [ "Jaipur", "Jodhpur", "Bikaner", "Udaipur", "Ajmer", "Bhilwara", "Alwar", "Bharatpur", "Pali", "Barmer", "Sikar", "Tonk", "Sadulpur", "Sawai Madhopur", "Nagaur", "Makrana", "Sujangarh", "Sardarshahar", "Ladnu", "Ratangarh", "Nokha", "Nimbahera", "Suratgarh", "Rajsamand", "Lachhmangarh", "Rajgarh (Churu)", "Nasirabad", "Nohar", "Phalodi", "Nathdwara", "Pilani", "Merta City", "Sojat", "Neem-Ka-Thana", "Sirohi", "Pratapgarh", "Rawatbhata", "Sangaria", "Lalsot", "Pilibanga", "Pipar City", "Taranagar", "Vijainagar, Ajmer", "Sumerpur", "Sagwara", "Ramganj Mandi", "Lakheri", "Udaipurwati", "Losal", "Sri Madhopur", "Ramngarh", "Rawatsar", "Rajakhera", "Shahpura", "Shahpura", "Raisinghnagar", "Malpura", "Nadbai", "Sanchore", "Nagar", "Rajgarh (Alwar)", "Sheoganj", "Sadri", "Todaraisingh", "Todabhim", "Reengus", "Rajaldesar", "Sadulshahar", "Sambhar", "Prantij", "Mount Abu", "Mangrol", "Phulera", "Mandawa", "Pindwara", "Mandalgarh", "Takhatgarh" ], "Assam": [ "Guwahati", "Silchar", "Dibrugarh", "Nagaon", "Tinsukia", "Jorhat", "Bongaigaon City", "Dhubri", "Diphu", "North Lakhimpur", "Tezpur", "Karimganj", "Sibsagar", "Goalpara", "Barpeta", "Lanka", "Lumding", "Mankachar", "Nalbari", "Rangia", "Margherita", "Mangaldoi", "Silapathar", "Mariani", "Marigaon" ], "Odisha": [ "Bhubaneswar", "Cuttack", "Raurkela", "Brahmapur", "Sambalpur", "Puri", "Baleshwar Town", "Baripada Town", "Bhadrak", "Balangir", "Jharsuguda", "Bargarh", "Paradip", "Bhawanipatna", "Dhenkanal", "Barbil", "Kendujhar", "Sunabeda", "Rayagada", "Jatani", "Byasanagar", "Kendrapara", "Rajagangapur", "Parlakhemundi", "Talcher", "Sundargarh", "Phulabani", "Pattamundai", "Titlagarh", "Nabarangapur", "Soro", "Malkangiri", "Rairangpur", "Tarbha" ], "Chhattisgarh": [ "Raipur", "Bhilai Nagar", "Korba", "Bilaspur", "Durg", "Rajnandgaon", "Jagdalpur", "Raigarh", "Ambikapur", "Mahasamund", "Dhamtari", "Chirmiri", "Bhatapara", "Dalli-Rajhara", "Naila Janjgir", "Tilda Newra", "Mungeli", "Manendragarh", "Sakti" ], "Jammu and Kashmir": [ "Srinagar", "Jammu", "Baramula", "Anantnag", "Sopore", "KathUrban Agglomeration", "Rajauri", "Punch", "Udhampur" ], "Karnataka": [ "Bengaluru", "Hubli-Dharwad", "Belagavi", "Mangaluru", "Davanagere", "Ballari", "Mysore", "Tumkur", "Shivamogga", "Raayachuru", "Robertson Pet", "Kolar", "Mandya", "Udupi", "Chikkamagaluru", "Karwar", "Ranebennuru", "Ranibennur", "Ramanagaram", "Gokak", "Yadgir", "Rabkavi Banhatti", "Shahabad", "Sirsi", "Sindhnur", "Tiptur", "Arsikere", "Nanjangud", "Sagara", "Sira", "Puttur", "Athni", "Mulbagal", "Surapura", "Siruguppa", "Mudhol", "Sidlaghatta", "Shahpur", "Saundatti-Yellamma", "Wadi", "Manvi", "Nelamangala", "Lakshmeshwar", "Ramdurg", "Nargund", "Tarikere", "Malavalli", "Savanur", "Lingsugur", "Vijayapura", "Sankeshwara", "Madikeri", "Talikota", "Sedam", "Shikaripur", "Mahalingapura", "Mudalagi", "Muddebihal", "Pavagada", "Malur", "Sindhagi", "Sanduru", "Afzalpur", "Maddur", "Madhugiri", "Tekkalakote", "Terdal", "Mudabidri", "Magadi", "Navalgund", "Shiggaon", "Shrirangapattana", "Sindagi", "Sakaleshapura", "Srinivaspur", "Ron", "Mundargi", "Sadalagi", "Piriyapatna", "Adyar" ], "Manipur": [ "Imphal", "Thoubal", "Lilong", "Mayang Imphal" ], "Kerala": [ "Thiruvananthapuram", "Kochi", "Kozhikode", "Kollam", "Thrissur", "Palakkad", "Alappuzha", "Malappuram", "Ponnani", "Vatakara", "Kanhangad", "Taliparamba", "Koyilandy", "Neyyattinkara", "Kayamkulam", "Nedumangad", "Kannur", "Tirur", "Kottayam", "Kasaragod", "Kunnamkulam", "Ottappalam", "Thiruvalla", "Thodupuzha", "Chalakudy", "Changanassery", "Punalur", "Nilambur", "Cherthala", "Perinthalmanna", "Mattannur", "Shoranur", "Varkala", "Paravoor", "Pathanamthitta", "Peringathur", "Attingal", "Kodungallur", "Pappinisseri", "Chittur-Thathamangalam", "Muvattupuzha", "Adoor", "Mavelikkara", "Mavoor", "Perumbavoor", "Vaikom", "Palai", "Panniyannur", "Guruvayoor", "Puthuppally", "Panamattom" ], "Delhi": [ "Delhi", "New Delhi" ], "Dadra and Nagar Haveli": [ "Silvassa" ], "Puducherry": [ "Pondicherry", "Karaikal", "Yanam", "Mahe" ], "Uttarakhand": [ "Dehradun", "Hardwar", "Haldwani-cum-Kathgodam", "Srinagar", "Kashipur", "Roorkee", "Rudrapur", "Rishikesh", "Ramnagar", "Pithoragarh", "Manglaur", "Nainital", "Mussoorie", "Tehri", "Pauri", "Nagla", "Sitarganj", "Bageshwar" ], "Uttar Pradesh": [ "Lucknow", "Kanpur", "Firozabad", "Agra", "Meerut", "Varanasi", "Allahabad", "Amroha", "Moradabad", "Aligarh", "Saharanpur", "Noida", "Loni", "Jhansi", "Shahjahanpur", "Rampur", "Modinagar", "Hapur", "Etawah", "Sambhal", "Orai", "Bahraich", "Unnao", "Rae Bareli", "Lakhimpur", "Sitapur", "Lalitpur", "Pilibhit", "Chandausi", "Hardoi ", "Azamgarh", "Khair", "Sultanpur", "Tanda", "Nagina", "Shamli", "Najibabad", "Shikohabad", "Sikandrabad", "Shahabad, Hardoi", "Pilkhuwa", "Renukoot", "Vrindavan", "Ujhani", "Laharpur", "Tilhar", "Sahaswan", "Rath", "Sherkot", "Kalpi", "Tundla", "Sandila", "Nanpara", "Sardhana", "Nehtaur", "Seohara", "Padrauna", "Mathura", "Thakurdwara", "Nawabganj", "Siana", "Noorpur", "Sikandra Rao", "Puranpur", "Rudauli", "Thana Bhawan", "Palia Kalan", "Zaidpur", "Nautanwa", "Zamania", "Shikarpur, Bulandshahr", "Naugawan Sadat", "Fatehpur Sikri", "Shahabad, Rampur", "Robertsganj", "Utraula", "Sadabad", "Rasra", "Lar", "Lal Gopalganj Nindaura", "Sirsaganj", "Pihani", "Shamsabad, Agra", "Rudrapur", "Soron", "SUrban Agglomerationr", "Samdhan", "Sahjanwa", "Rampur Maniharan", "Sumerpur", "Shahganj", "Tulsipur", "Tirwaganj", "PurqUrban Agglomerationzi", "Shamsabad, Farrukhabad", "Warhapur", "Powayan", "Sandi", "Achhnera", "Naraura", "Nakur", "Sahaspur", "Safipur", "Reoti", "Sikanderpur", "Saidpur", "Sirsi", "Purwa", "Parasi", "Lalganj", "Phulpur", "Shishgarh", "Sahawar", "Samthar", "Pukhrayan", "Obra", "Niwai", "Mirzapur" ], "Bihar": [ "Patna", "Gaya", "Bhagalpur", "Muzaffarpur", "Darbhanga", "Arrah", "Begusarai", "Chhapra", "Katihar", "Munger", "Purnia", "Saharsa", "Sasaram", "Hajipur", "Dehri-on-Sone", "Bettiah", "Motihari", "Bagaha", "Siwan", "Kishanganj", "Jamalpur", "Buxar", "Jehanabad", "Aurangabad", "Lakhisarai", "Nawada", "Jamui", "Sitamarhi", "Araria", "Gopalganj", "Madhubani", "Masaurhi", "Samastipur", "Mokameh", "Supaul", "Dumraon", "Arwal", "Forbesganj", "BhabUrban Agglomeration", "Narkatiaganj", "Naugachhia", "Madhepura", "Sheikhpura", "Sultanganj", "Raxaul Bazar", "Ramnagar", "Mahnar Bazar", "Warisaliganj", "Revelganj", "Rajgir", "Sonepur", "Sherghati", "Sugauli", "Makhdumpur", "Maner", "Rosera", "Nokha", "Piro", "Rafiganj", "Marhaura", "Mirganj", "Lalganj", "Murliganj", "Motipur", "Manihari", "Sheohar", "Maharajganj", "Silao", "Barh", "Asarganj" ], "Gujarat": [ "Ahmedabad", "Surat", "Vadodara", "Rajkot", "Bhavnagar", "Jamnagar", "Nadiad", "Porbandar", "Anand", "Morvi", "Mahesana", "Bharuch", "Vapi", "Navsari", "Veraval", "Bhuj", "Godhra", "Palanpur", "Valsad", "Patan", "Deesa", "Amreli", "Anjar", "Dhoraji", "Khambhat", "Mahuva", "Keshod", "Wadhwan", "Ankleshwar", "Savarkundla", "Kadi", "Visnagar", "Upleta", "Una", "Sidhpur", "Unjha", "Mangrol", "Viramgam", "Modasa", "Palitana", "Petlad", "Kapadvanj", "Sihor", "Wankaner", "Limbdi", "Mandvi", "Thangadh", "Vyara", "Padra", "Lunawada", "Rajpipla", "Vapi", "Umreth", "Sanand", "Rajula", "Radhanpur", "Mahemdabad", "Ranavav", "Tharad", "Mansa", "Umbergaon", "Talaja", "Vadnagar", "Manavadar", "Salaya", "Vijapur", "Pardi", "Rapar", "Songadh", "Lathi", "Adalaj", "Chhapra", "Gandhinagar" ], "Telangana": [ "Hyderabad", "Warangal", "Nizamabad", "Karimnagar", "Ramagundam", "Khammam", "Mahbubnagar", "Mancherial", "Adilabad", "Suryapet", "Jagtial", "Miryalaguda", "Nirmal", "Kamareddy", "Kothagudem", "Bodhan", "Palwancha", "Mandamarri", "Koratla", "Sircilla", "Tandur", "Siddipet", "Wanaparthy", "Kagaznagar", "Gadwal", "Sangareddy", "Bellampalle", "Bhongir", "Vikarabad", "Jangaon", "Bhadrachalam", "Bhainsa", "Farooqnagar", "Medak", "Narayanpet", "Sadasivpet", "Yellandu", "Manuguru", "Kyathampalle", "Nagarkurnool" ], "Meghalaya": [ "Shillong", "Tura", "Nongstoin" ], "Himachal Praddesh": [ "Manali" ], "Arunachal Pradesh": [ "Naharlagun", "Pasighat" ], "Maharashtra": [ "Mumbai", "Pune", "Nagpur", "Thane", "Nashik", "Kalyan-Dombivali", "Vasai-Virar", "Solapur", "Mira-Bhayandar", "Bhiwandi", "Amravati", "Nanded-Waghala", "Sangli", "Malegaon", "Akola", "Latur", "Dhule", "Ahmednagar", "Ichalkaranji", "Parbhani", "Panvel", "Yavatmal", "Achalpur", "Osmanabad", "Nandurbar", "Satara", "Wardha", "Udgir", "Aurangabad", "Amalner", "Akot", "Pandharpur", "Shrirampur", "Parli", "Washim", "Ambejogai", "Manmad", "Ratnagiri", "Uran Islampur", "Pusad", "Sangamner", "Shirpur-Warwade", "Malkapur", "Wani", "Lonavla", "Talegaon Dabhade", "Anjangaon", "Umred", "Palghar", "Shegaon", "Ozar", "Phaltan", "Yevla", "Shahade", "Vita", "Umarkhed", "Warora", "Pachora", "Tumsar", "Manjlegaon", "Sillod", "Arvi", "Nandura", "Vaijapur", "Wadgaon Road", "Sailu", "Murtijapur", "Tasgaon", "Mehkar", "Yawal", "Pulgaon", "Nilanga", "Wai", "Umarga", "Paithan", "Rahuri", "Nawapur", "Tuljapur", "Morshi", "Purna", "Satana", "Pathri", "Sinnar", "Uchgaon", "Uran", "Pen", "Karjat", "Manwath", "Partur", "Sangole", "Mangrulpir", "Risod", "Shirur", "Savner", "Sasvad", "Pandharkaoda", "Talode", "Shrigonda", "Shirdi", "Raver", "Mukhed", "Rajura", "Vadgaon Kasba", "Tirora", "Mahad", "Lonar", "Sawantwadi", "Pathardi", "Pauni", "Ramtek", "Mul", "Soyagaon", "Mangalvedhe", "Narkhed", "Shendurjana", "Patur", "Mhaswad", "Loha", "Nandgaon", "Warud" ], "Goa": [ "Marmagao", "Panaji", "Margao", "Mapusa" ], "West Bengal": [ "Kolkata", "Siliguri", "Asansol", "Raghunathganj", "Kharagpur", "Naihati", "English Bazar", "Baharampur", "Hugli-Chinsurah", "Raiganj", "Jalpaiguri", "Santipur", "Balurghat", "Medinipur", "Habra", "Ranaghat", "Bankura", "Nabadwip", "Darjiling", "Purulia", "Arambagh", "Tamluk", "AlipurdUrban Agglomerationr", "Suri", "Jhargram", "Gangarampur", "Rampurhat", "Kalimpong", "Sainthia", "Taki", "Murshidabad", "Memari", "Paschim Punropara", "Tarakeswar", "Sonamukhi", "PandUrban Agglomeration", "Mainaguri", "Malda", "Panchla", "Raghunathpur", "Mathabhanga", "Monoharpur", "Srirampore", "Adra" ] }

    const stateDropdown = document.getElementById("State");
    const cityDropdown = document.getElementById("City");

    // Populate states
    Object.keys(stateCityData).forEach(state => {
      let option = document.createElement("option");
      option.value = state;
      option.textContent = state;
      stateDropdown.appendChild(option);
    });

    // Update cities when state changes
    stateDropdown.addEventListener("change", function() {
      cityDropdown.innerHTML = '<option value="">-- Select City --</option>'; // Reset
      if (this.value) {
        stateCityData[this.value].forEach(city => {
          let option = document.createElement("option");
          option.value = city;
          option.textContent = city;
          cityDropdown.appendChild(option);
        });
      }
    });
  </script>
<script>
  // Preselect course from URL parameter
  document.addEventListener('DOMContentLoaded', function() {
    const urlParams = new URLSearchParams(window.location.search);
    const selectedCourse = urlParams.get('StudentCourse');
    
    if (selectedCourse) {
      const courseSelect = document.querySelector('select[name="StudentCourse"]');
      if (courseSelect) {
        // Find and select the matching option
        for (let i = 0; i < courseSelect.options.length; i++) {
          if (courseSelect.options[i].value === selectedCourse) {
            courseSelect.selectedIndex = i;
            courseSelect.style.color = '#f5f5f5';
            break;
          }
        }
      }
    }
  });
</script>
  <script src="../../assets/vendors/js/vendor.bundle.base.js"></script>
  <script src="../../assets/js/off-canvas.js"></script>
  <script src="../../assets/js/hoverable-collapse.js"></script>
  <script src="../../assets/js/misc.js"></script>
  <script src="../../assets/js/settings.js"></script>
  <script src="../../assets/js/todolist.js"></script>
</body>
</html>

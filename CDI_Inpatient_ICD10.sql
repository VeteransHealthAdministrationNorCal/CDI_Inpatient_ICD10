/* vhacdwdwhsql33.vha.med.va.gov */
SELECT DISTINCT
  --Ward.DivisionName,
  Ward.WardLocationName,
  Inpat.AdmitDateTime,
  SPat.PatientSSN,
  SPat.PatientLastName,
  SPat.PatientFirstName,
  Inpat.AdmitDiagnosis,
  ICD.ICD10Code,
  Describe.ICD10Description,
  POA.PresentOnAdmissionCode,
  Staff.StaffName,
  Staff.PositionTitle

FROM
  LSV.SPatient.SPatient AS SPat
  INNER JOIN LSV.Inpat.Inpatient AS Inpat
    ON SPat.PatientSID = Inpat.PatientSID
  INNER JOIN LSV.Inpat.PresentOnAdmission AS POA
    ON Inpat.PatientSID = POA.PatientSID
  INNER JOIN LSV.Dim.ICD10 AS ICD
    ON POA.ICD10SID = ICD.ICD10SID
  INNER JOIN LSV.Dim.ICD10DescriptionVersion AS Describe
    ON ICD.ICD10SID = Describe.ICD10SID
  INNER JOIN LSV.Dim.WardLocation AS Ward
    ON Inpat.AdmitWardLocationSID = Ward.WardLocationSID
  INNER JOIN LSV.SStaff.SStaff AS Staff
    ON Inpat.ProviderSID = Staff.StaffSID

WHERE
  Inpat.sta3n = '612'
  AND Ward.DivisionName = 'SACRAMENTO MEDICAL CENTER'
  AND Inpat.AdmitDateTime > DATEADD(DD, -180, GETDATE())
  AND Inpat.DischargeDateTime IS NULL
  AND SPat.DeathDateTime IS NULL

ORDER BY
  WardLocationName, AdmitDateTime, PatientSSN
/*** VhaCdwDwhSql33.vha.med.va.gov ***/
SELECT DISTINCT
  Ward.WardLocationName,
  Inpat.AdmitDateTime,
  SPat.PatientSID,
  SPat.PatientSSN,
  SPat.PatientLastName,
  SPat.PatientFirstName,
  Inpat.AdmitDiagnosis,
  CPRS.OrderText,
  ICD.ICD10Code,
  Describe.ICD10Description,
  POA.PresentOnAdmissionCode,
  Staff.StaffName,
  Staff.PositionTitle,
  Providers.PrimaryPosition

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
  INNER JOIN LSV.PCMM.PatientProviders AS Providers
    ON SPat.PatientSID = Providers.PatientSID
  INNER JOIN LSV.CPRSOrder.OrderAction AS CPRS
    ON SPat.PatientSID = CPRS.PatientSID

WHERE
  Inpat.sta3n = '612'
  AND Ward.DivisionName = 'SACRAMENTO MEDICAL CENTER'
  AND Inpat.AdmitDateTime > DATEADD(DD, -180, GETDATE())
  AND Inpat.DischargeDateTime IS NULL
  AND SPat.DeathDateTime IS NULL
  AND Providers.Team NOT LIKE '%ZZ%'
  AND (
    Providers.PrimaryPosition = 'ATTENDING'
    OR Providers.PrimaryStandardPosition IN (
      'PHYSICIAN-ATTENDING',
      'RESIDENT (PHYSICIAN)'
	)
  )
  AND CPRS.OrderText LIKE '%ADMIT%'
  AND CPRS.OrderActionDateTime BETWEEN DATEADD(DD, -1, Inpat.AdmitDateTime) AND DATEADD(DD, +1, Inpat.AdmitDateTime)

ORDER BY
  WardLocationName, AdmitDateTime, PatientSSN

package com.example.pharmacyodering.prescription;

import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/prescriptions")
public class PrescriptionController {

    private final PrescriptionService prescriptionService;

    public PrescriptionController(PrescriptionService prescriptionService) {
        this.prescriptionService = prescriptionService;
    }

    @PostMapping(value = "/upload", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<PrescriptionResponse> uploadPrescription(
            @RequestParam("userId") Long userId,
            @RequestPart("file") MultipartFile file,
            @RequestParam(value = "notes", required = false) String notes) throws IOException {
        PrescriptionResponse response = prescriptionService.uploadPrescription(userId, file, notes);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/user/{userId}")
    public ResponseEntity<List<PrescriptionResponse>> getPrescriptionsByUser(@PathVariable Long userId) {
        return ResponseEntity.ok(prescriptionService.getPrescriptionsByUserId(userId));
    }

    @PutMapping("/{id}/approve")
    public ResponseEntity<PrescriptionResponse> approvePrescription(@PathVariable Long id) {
        return ResponseEntity.ok(prescriptionService.updatePrescriptionStatus(id, PrescriptionStatus.APPROVED));
    }

    @PutMapping("/{id}/reject")
    public ResponseEntity<PrescriptionResponse> rejectPrescription(@PathVariable Long id) {
        return ResponseEntity.ok(prescriptionService.updatePrescriptionStatus(id, PrescriptionStatus.REJECTED));
    }
}

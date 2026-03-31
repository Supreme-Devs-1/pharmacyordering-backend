package com.example.pharmacyodering.prescription;

import com.example.pharmacyodering.user.User;
import com.example.pharmacyodering.user.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class PrescriptionService {

    private final PrescriptionRepository prescriptionRepository;
    private final UserRepository userRepository;
    private final String UPLOAD_DIR = "uploads/prescriptions/";

    public PrescriptionService(PrescriptionRepository prescriptionRepository, UserRepository userRepository) {
        this.prescriptionRepository = prescriptionRepository;
        this.userRepository = userRepository;
        File directory = new File(UPLOAD_DIR);
        if (!directory.exists()) {
            boolean created = directory.mkdirs();
        }
    }

    public PrescriptionResponse uploadPrescription(Long userId, MultipartFile file, String notes) throws IOException {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found with id: " + userId));

        String fileName = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
        Path filePath = Paths.get(UPLOAD_DIR + fileName);
        Files.copy(file.getInputStream(), filePath);

        Prescription prescription = new Prescription();
        prescription.setUser(user);
        prescription.setFileUrl(filePath.toString());
        prescription.setNotes(notes);
        prescription.setStatus(PrescriptionStatus.PENDING);
        prescription.setCreatedAt(LocalDateTime.now());

        Prescription saved = prescriptionRepository.save(prescription);
        return mapToResponse(saved);
    }

    public List<PrescriptionResponse> getPrescriptionsByUserId(Long userId) {
        return prescriptionRepository.findByUserId(userId)
                .stream()
                .map(this::mapToResponse)
                .collect(Collectors.toList());
    }

    public PrescriptionResponse updatePrescriptionStatus(Long id, PrescriptionStatus status) {
        Prescription prescription = prescriptionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Prescription not found with id: " + id));
        prescription.setStatus(status);
        Prescription updated = prescriptionRepository.save(prescription);
        return mapToResponse(updated);
    }

    private PrescriptionResponse mapToResponse(Prescription prescription) {
        return PrescriptionResponse.builder()
                .id(prescription.getId())
                .userId(prescription.getUser().getId())
                .username(prescription.getUser().getUsername())
                .fileUrl(prescription.getFileUrl())
                .status(prescription.getStatus())
                .notes(prescription.getNotes())
                .createdAt(prescription.getCreatedAt())
                .build();
    }
}

package com.example.los.controller;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;
@RestController
@RequestMapping("/api/loans")
public class LoanController {
  @GetMapping("/health")
  public ResponseEntity<String> health() { return ResponseEntity.ok("OK"); }
  @PostMapping("/apply")
  public ResponseEntity<Map<String,String>> apply(@RequestBody Map<String,Object> payload) {
    return ResponseEntity.ok(Map.of("applicationId","APP-"+System.currentTimeMillis(),"status","SUBMITTED"));
  }
}

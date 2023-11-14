package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Device;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource
public interface DeviceRepository extends JpaRepository<Device, Integer> {
}

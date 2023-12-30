package com.example.environmentalcontrol.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "`Incidents`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Incident {

    @Id
    @Column(name = "`PK_Incident`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`incident_date`")
    private LocalDate incidentDate;

    @Column(name = "`log_water`")
    private Double logWater;

    @Column(name = "`log_gas`")
    private Double logGas;

    @Column(name = "`company_name`")
    private String companyName;

    @Column(name = "`founder_fio`")
    private String founderFio;

    @Column(name = "`responsible_employee_fio`")
    private String responsibleEmployeeFio;

    @Column(name = "`device_serial_number`")
    private String deviceSerialNumber;
}

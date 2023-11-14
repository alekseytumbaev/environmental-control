package com.example.environmentalcontrol.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.time.LocalDate;

@Entity
@Table(name = "`Device`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Device {

    @Id
    @Column(name = "`PK_Device`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`serial_number`")
    private String serialNumber;

    /**
     * Срок службы (до какого числа будет работать)
     */
    @Column(name = "`long_life`")
    private LocalDate longLife;

    @Column(name = "`data_installed`")
    private LocalDate dataInstalled;

    /**
     * Дата последнего обслуживания
     */
    @Column(name = "`date_lastServ`")
    private LocalDate dateLastServ;

    @ManyToOne
    @JoinColumn(name = "`PK_Company`")
    private Company company;

    @ManyToOne
    @JoinColumn(name = "`PK_SensorGase`")
    private SensorGas sensorGas;

    @ManyToOne
    @JoinColumn(name = "`PK_SensorWater`")
    private SensorWater sensorWater;
}

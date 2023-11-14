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
@Table(name = "`LogGas`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class LogGas {

    @Id
    @Column(name = "`PK_LogGas`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`Indicator`")
    private Double indicator;

    @Column(name = "`date_lastUpdate`")
    private LocalDate dateLastUpdate;

    @ManyToOne
    @JoinColumn(name = "`PK_Device`")
    private Device device;

    @ManyToOne
    @JoinColumn(name = "`PK_PollutionGases`")
    private PollutionGas pollutionGas;

}

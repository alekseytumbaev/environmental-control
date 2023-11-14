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

@Entity
@Table(name = "`SensorGas`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class SensorGas {

    @Id
    @Column(name = "`PK_SensorGase`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`name`")
    private String name;

    @Column(name = "`sensetivity`")
    private Integer sensitivity;

    @Column(name = "`marks`")
    private String marks;

    @ManyToOne
    @JoinColumn(name = "`PK_Brand`")
    private Brand brand;
}

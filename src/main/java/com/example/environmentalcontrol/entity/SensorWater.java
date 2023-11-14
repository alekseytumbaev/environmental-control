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
@Table(name = "`SensorWater`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class SensorWater {

    @Id
    @Column(name = "`PK_SensorWater`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`name`")
    private String name;

    @Column(name = "`sensitivity`")
    private Integer sensitivity;

    @Column(name = "`mark`")
    private String mark;

    @ManyToOne
    @JoinColumn(name = "`PK_Brand`")
    private Brand brand;
}

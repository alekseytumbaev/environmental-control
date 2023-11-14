package com.example.environmentalcontrol.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.JoinTable;
import jakarta.persistence.ManyToMany;
import jakarta.persistence.Table;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "`Company`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Company {

    @Id
    @Column(name = "`PK_Company`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`name`")
    private String name;

    @Column(name = "`date_foundation`")
    private LocalDate dateFoundation;

    @Column(name = "`purpose_prodaction`")
    private String purposeProduction;

    @Column(name = "`norm_gas_emission`")
    private Double normGasEmission;

    @Column(name = "`norm_water_emisson`")
    private Double normWaterEmission;

    @ManyToMany
    @JoinTable(
            name = "`Type_Company-Company`",
            joinColumns = @JoinColumn(name = "`PK_Company`"),
            inverseJoinColumns = @JoinColumn(name = "`PK_Type_Company`"))
    private Set<TypeCompany> types = new HashSet<>();
}

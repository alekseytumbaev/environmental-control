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
@Table(name = "`Founders`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class Founder {

    @Id
    @Column(name = "`PK_Founders`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`FIO`")
    private String fio;

    @Column(name = "`number_phone`")
    private String numberPhone;

    @Column(name = "`seria_passport`")
    private String seriaPassport;

    @Column(name = "`number_passport`")
    private String numberPassport;

    @ManyToOne
    @JoinColumn(name = "`PK_Company`")
    private Company company;
}

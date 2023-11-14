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
@Table(name = "`ResponsibleSotrud`")
@Data
@AllArgsConstructor
@NoArgsConstructor
@EqualsAndHashCode(onlyExplicitlyIncluded = true)
public class ResponsibleSotrud {

    @Id
    @Column(name = "`PK_ResponsibleSotrud`")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @EqualsAndHashCode.Include
    private Integer id;

    @Column(name = "`FIO`")
    private String fio;

    @Column(name = "`number`")
    private String number;

    @Column(name = "`seria_passport`")
    private String seriaPassport;

    @Column(name = "`number_passport`")
    private String numberPassport;

    @Column(name = "`type_activity`")
    private String typeActivity;

    @ManyToOne
    @JoinColumn(name = "`PK_Company`")
    private Company company;
}

package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Device;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;

@RepositoryRestResource
public interface DeviceRepository extends JpaRepository<Device, Integer> {


    /**
     * Получение датчиков, которые требуют проверки или замены на
     * данном предприятии.
     */
    @Query(value = """
            select d.* from "Device" d
            join "Company" c on d."PK_Company" = c."PK_Company"
            where c."PK_Company" = :companyId
            and (d."long_life" < current_date
            or extract(YEAR from age(current_date, d."date_lastServ")) > 2)
            """, nativeQuery = true)
    List<Device> findAllToCheckOrReplaceByCompanyId(int companyId);
}

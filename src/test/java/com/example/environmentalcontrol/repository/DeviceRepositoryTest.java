package com.example.environmentalcontrol.repository;

import com.example.environmentalcontrol.entity.Device;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.jdbc.AutoConfigureTestDatabase;
import org.springframework.boot.test.autoconfigure.orm.jpa.DataJpaTest;
import org.springframework.boot.test.autoconfigure.orm.jpa.TestEntityManager;

import java.util.List;

@DataJpaTest
@AutoConfigureTestDatabase(replace = AutoConfigureTestDatabase.Replace.NONE)
class DeviceRepositoryTest {

    @Autowired
    TestEntityManager tem;

    @Autowired
    DeviceRepository deviceRepo;

    @Test
    void testFindAllToCheckOrReplaceByCompanyId() {
        List<Device> devices = deviceRepo.findAllToCheckOrReplaceByCompanyId(4);
        devices.forEach(System.out::println);
    }
}

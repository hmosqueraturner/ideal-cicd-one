package com.imoto.acid.acidJavaApp;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Unit test for simple Java App.
 */

public class AcidJavaAppTest
{
    @Test
    public void testAppConstructor() {
        AcidJavaApp app1 = new AcidJavaApp();
        AcidJavaApp app2 = new AcidJavaApp();
        assertEquals(app1.getMessage(), app2.getMessage());
    }

    @Test
    public void testAppMessage()
    {
        AcidJavaApp app = new AcidJavaApp();
        assertEquals("Hello ACiD World!", app.getMessage());
    }
}

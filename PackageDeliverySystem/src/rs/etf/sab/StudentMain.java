package rs.etf.sab;

import rs.etf.sab.operations.CityOperations;
import rs.etf.sab.operations.CourierOperations;
import rs.etf.sab.operations.CourierRequestOperation;
import rs.etf.sab.operations.DistrictOperations;
import rs.etf.sab.operations.GeneralOperations;
import rs.etf.sab.operations.PackageOperations;
import rs.etf.sab.operations.UserOperations;
import rs.etf.sab.operations.VehicleOperations;
//import rs.etf.sab.*;
import rs.etf.sab.tests.TestHandler;
import rs.etf.sab.tests.TestRunner;


public class StudentMain {

    public static void main(String[] args) {
        CityOperations cityOperations = new CityOperationsConcrete(); // Change this to your implementation.
        DistrictOperations districtOperations = new DistrictOperationsConcrete(); // Do it for all classes.
        CourierOperations courierOperations = new CourierOperationsConcrete(); // e.g. = new MyDistrictOperations();
        CourierRequestOperation courierRequestOperation = new CourierRequestOperationConcrete();
        GeneralOperations generalOperations = new GeneralOperationsConcrete();
        UserOperations userOperations = new UserOperationsConcrete();
        VehicleOperations vehicleOperations = new VehicleOperationsConcrete();
        PackageOperations packageOperations = new PackageOperationsConcrete();

        TestHandler.createInstance(
                cityOperations,
                courierOperations,
                courierRequestOperation,
                districtOperations,
                generalOperations,
                userOperations,
                vehicleOperations,
                packageOperations);

        TestRunner.runTests();
    }
}

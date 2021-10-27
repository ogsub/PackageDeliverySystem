package rs.etf.sab;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;

import rs.etf.sab.operations.CityOperations;
import rs.etf.sab.operations.DistrictOperations;
import rs.etf.sab.operations.VehicleOperations;

public class VehicleOperationsConcrete implements VehicleOperations {

	private Connection connection = DB.getInstance().getConnection();
	
	@Override
	public boolean changeConsumption(String licensePlateNumber, BigDecimal fuelConsumption) {
		try (PreparedStatement ps = connection.prepareStatement("UPDATE Vozilo SET Potrosnja=? WHERE RegistracijaBroj=?");) {
			ps.setBigDecimal(1, fuelConsumption);
			ps.setString(2, licensePlateNumber);

			if(ps.executeUpdate() == 1)
				return true;
			 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean changeFuelType(String licensePlateNumber, int fuelType) {
		try (PreparedStatement ps = connection.prepareStatement("UPDATE Vozilo SET TipGoriva=? WHERE RegistracijaBroj=?");) {
			ps.setInt(1, fuelType);
			ps.setString(2, licensePlateNumber);

			if(ps.executeUpdate() == 1)
				return true;
			
				
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public int deleteVehicles(String... licencePlateNumbers) {
		int numDeleted = 0;
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Vozilo WHERE RegistracijaBroj = ?");) {
			for (String s : licencePlateNumbers) {
				ps.setString(1, s);
				int rowsAffected = ps.executeUpdate();
				numDeleted += rowsAffected;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return numDeleted;
	}

	@Override
	public List<String> getAllVehichles() {
		List<String> listaRegistracija = new ArrayList<String>();
		try (PreparedStatement ps = connection.prepareStatement("select RegistracijaBroj from Vozilo");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaRegistracija.add(rs.getString(1));
			}
			return listaRegistracija;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public boolean insertVehicle(String licencePlateNumber, int fuelType, BigDecimal fuelConsumtion) {
		try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Vozilo (RegistracijaBroj, TipGoriva, Potrosnja, Zauzeta) VALUES (?,?,?,0)",
				Statement.RETURN_GENERATED_KEYS);) {
			ps.setString(1, licencePlateNumber);
			ps.setInt(2, fuelType);
			ps.setBigDecimal(3, fuelConsumtion);

			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys();) {
				if (rs.next()) {
					return true;
				}
			} catch (Exception e) {
				//e.printStackTrace();
			} 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public static void main(String[] args) {
		   
        VehicleOperations vehicleOperations = new VehicleOperationsConcrete();
        //DistrictOperations districtOperations = new so170425_DistrictOperations();
        GeneralOperationsConcrete general = new GeneralOperationsConcrete();
        
        general.eraseAll();
        
        String licencePlateNumber = "BG234DU";
        BigDecimal fuelConsumption = new BigDecimal(6.3);
        int fuelType = 1;
        Assert.assertTrue(vehicleOperations.insertVehicle(licencePlateNumber, fuelType, fuelConsumption));
    
        general.eraseAll();

        licencePlateNumber = "BG234DU";
        fuelConsumption = new BigDecimal(6.3);
        fuelType = 1;
        vehicleOperations.insertVehicle(licencePlateNumber, fuelType, fuelConsumption);
        Assert.assertEquals(1L, vehicleOperations.deleteVehicles(licencePlateNumber));
    
        general.eraseAll();

        licencePlateNumber = "BG234DU";
        fuelConsumption = new BigDecimal(6.3);
        fuelType = 1;
        vehicleOperations.insertVehicle(licencePlateNumber, fuelType, fuelConsumption);
        Assert.assertTrue(vehicleOperations.getAllVehichles().contains(licencePlateNumber));
        
        general.eraseAll();

        licencePlateNumber = "BG234DU";
        fuelConsumption = new BigDecimal(6.3);
        fuelType = 1;
        vehicleOperations.insertVehicle(licencePlateNumber, fuelType, fuelConsumption);
        Assert.assertTrue(vehicleOperations.changeFuelType(licencePlateNumber, 2));
   
        general.eraseAll();
 
        licencePlateNumber = "BG234DU";
        fuelConsumption = new BigDecimal(6.3);
        fuelType = 1;
        vehicleOperations.insertVehicle(licencePlateNumber, fuelType, fuelConsumption);
        Assert.assertTrue(vehicleOperations.changeConsumption(licencePlateNumber, new BigDecimal(7.3)));
   
	}
	
}

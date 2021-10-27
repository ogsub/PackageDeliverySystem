package rs.etf.sab;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;

import rs.etf.sab.operations.CityOperations;
import rs.etf.sab.operations.DistrictOperations;
import rs.etf.sab.operations.GeneralOperations;
import rs.etf.sab.tests.TestHandler;

public class DistrictOperationsConcrete implements DistrictOperations{

	private Connection connection = DB.getInstance().getConnection();

	
	@Override
	public int deleteAllDistrictsFromCity(String nameOfTheCity) {
		try (PreparedStatement ps = connection.prepareStatement("DELETE \n"
				+ "from Opstina where IdGrad in ( \n"
				+ "	select O.IdGrad \n"
				+ "	from Grad G join Opstina O on (G.IdGrad = O.IdGrad) \n"
				+ "	where G.Naziv = ?\n"
				+ ")");) {
			ps.setString(1, nameOfTheCity);
			int rowsAffected = ps.executeUpdate();
			return rowsAffected;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public boolean deleteDistrict(int idDistrict) {
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Opstina WHERE IdOpstina = ?");) {
			ps.setInt(1, idDistrict);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected == 1)
				return true;
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	@Override
	public int deleteDistricts(String... names) {
		int numDeleted = 0;
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Opstina WHERE Naziv = ?");) {
			for (String s : names) {
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
	public List<Integer> getAllDistricts() {
		List listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select IdOpstina from Opstina");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getInt(1));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Integer> getAllDistrictsFromCity(int idCity) {
		List listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select IdOpstina from Opstina where IdGrad = ?");) {
			ps.setInt(1, idCity);
			
			try(ResultSet rs = ps.executeQuery();){
				while (rs.next()) {
					listaPrimarnihKljuceva.add(rs.getInt(1));
				}
				return listaPrimarnihKljuceva;
			}catch (Exception e) {
				//e.printStackTrace();
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	@Override
	public int insertDistrict(String name, int cityId, int xCord, int yCord) {
		try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Opstina (Naziv, xKoordinata, yKoordinata, IdGrad) VALUES (?,?,?,?)",
				Statement.RETURN_GENERATED_KEYS);) {
			ps.setString(1, name);
			ps.setInt(2, xCord);
			ps.setInt(3, yCord);
			ps.setInt(4, cityId);

			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys();) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			} catch (Exception e) {
				//e.printStackTrace();
			} 
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return -1;
	}
	
	public static void main(String[] args) {	    
	   
	        CityOperations cityOperations = new CityOperationsConcrete();
	        DistrictOperations districtOperations = new DistrictOperationsConcrete();
	        GeneralOperationsConcrete general = new GeneralOperationsConcrete();
	        
	        general.eraseAll();
	        
			int idCity = cityOperations .insertCity("Belgrade", "11000");
	        Assert.assertNotEquals(-1L, idCity);	        
			final int idDistrict = districtOperations.insertDistrict("Palilula", idCity, 10, 10);
	        Assert.assertNotEquals(-1L, idDistrict);
	        Assert.assertTrue(districtOperations.getAllDistrictsFromCity(idCity).contains(idDistrict));
	    
	        general.eraseAll();

	        idCity = cityOperations.insertCity("Belgrade", "11000");
	        Assert.assertNotEquals(-1L, idCity);
	        String districtOneName = "Palilula";
	        String districtTwoName = "Vozdovac";
	        int idDistrict1 = districtOperations.insertDistrict(districtOneName, idCity, 10, 10);
	        int idDistrict2 = districtOperations.insertDistrict(districtTwoName, idCity, 1, 10);
	        Assert.assertEquals(2L, districtOperations.deleteDistricts(districtOneName, districtTwoName));
	    
	        general.eraseAll();

	        idCity = cityOperations.insertCity("Belgrade", "11000");
	        Assert.assertNotEquals(-1L, idCity);
	        idDistrict1 = districtOperations.insertDistrict("Vozdovac", idCity, 10, 10);
	        Assert.assertTrue(districtOperations.deleteDistrict(idDistrict1));
	    
	        general.eraseAll();

	        String cityName = "Belgrade";
	        idCity = cityOperations.insertCity(cityName, "11000");
	        Assert.assertNotEquals(-1L, idCity);
	        districtOneName = "Palilula";
	        districtTwoName = "Vozdovac";
	        idDistrict1 = districtOperations.insertDistrict(districtOneName, idCity, 10, 10);
	        idDistrict2 = districtOperations.insertDistrict(districtTwoName, idCity, 1, 10);
	        //Assert.assertEquals(2L, districtOperations.deleteAllDistrictsFromCity(cityName));
	    
	        general.eraseAll();
	 
	        cityName = "Belgrade";
	        idCity = cityOperations.insertCity(cityName, "11000");
	        Assert.assertNotEquals(-1L, idCity);
	        districtOneName = "Palilula";
	        districtTwoName = "Vozdovac";
	        idDistrict1 = districtOperations.insertDistrict(districtOneName, idCity, 10, 10);
	        idDistrict2 = districtOperations.insertDistrict(districtTwoName, idCity, 1, 10);
	        Assert.assertTrue(districtOperations.getAllDistrictsFromCity(idCity).contains(idDistrict1));
	        Assert.assertTrue(districtOperations.getAllDistrictsFromCity(idCity).contains(idDistrict2));
	    
	}

}

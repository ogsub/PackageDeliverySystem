package rs.etf.sab;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import rs.etf.sab.operations.CityOperations;

public class CityOperationsConcrete implements CityOperations {
	
	private Connection connection = DB.getInstance().getConnection();

	@Override
	public int deleteCity(String... names) {
		int numDeleted = 0;
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Grad WHERE Naziv = ?");) {
			for (String s : names) {
				ps.setString(1, s);
				int rowsAffected = ps.executeUpdate();
				numDeleted += rowsAffected;
			}
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return numDeleted;
	}

	@Override
	public boolean deleteCity(int idCity) {
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Grad WHERE IdGrad = ?");) {
			ps.setInt(1, idCity);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected == 1)
				return true;
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return false;
	}

	@Override
	public List<Integer> getAllCities() {
		List listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select Naziv, PostanskiBroj, IdGrad from Grad");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getInt(3));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public int insertCity(String name, String postalCode) {
		try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Grad (Naziv, PostanskiBroj) VALUES (?,?)",
				Statement.RETURN_GENERATED_KEYS);) {
			ps.setString(1, name);
			ps.setString(2, postalCode);

			ps.executeUpdate();
			try (ResultSet rs = ps.getGeneratedKeys();) {
				if (rs.next()) {
					return rs.getInt(1);
				}
			} catch (Exception e) {
				//e.printStackTrace();
			}
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return -1;
	}

}

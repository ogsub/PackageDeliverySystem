package rs.etf.sab;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import rs.etf.sab.operations.CourierOperations;

public class CourierOperationsConcrete implements CourierOperations {

//	@Override
//	public boolean insertCourier(String p0, String p1) {
//		// TODO Auto-generated method stub
//		return false;
//	}
//
//	@Override
//	public boolean deleteCourier(String p0) {
//		// TODO Auto-generated method stub
//		return false;
//	}
//
//	@Override
//	public List<String> getCouriersWithStatus(int p0) {
//		// TODO Auto-generated method stub
//		return null;
//	}
//
//	@Override
//	public List<String> getAllCouriers() {
//		// TODO Auto-generated method stub
//		return null;
//	}
//
//	@Override
//	public BigDecimal getAverageCourierProfit(int p0) {
//		// TODO Auto-generated method stub
//		return null;
//	}

	private Connection connection = DB.getInstance().getConnection();
	
	@Override
	public boolean deleteCourier(String courierUserName) {
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Kurir WHERE KorIme = ?");) {
			ps.setString(1, courierUserName);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected == 1)
				return true;
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return false;
	}

	@Override
	public List<String> getAllCouriers() {
		List<String> listaPrimarnihKljuceva = new ArrayList<String>();
		try (PreparedStatement ps = connection.prepareStatement("select KorIme \n"
				+ "from Kurir\n"
				+ "order by OstvarenProfit DESC");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getString(1));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public BigDecimal getAverageCourierProfit(int numberOfDeliveries) {
		try (PreparedStatement ps = connection.prepareStatement("select avg(OstvarenProfit)\n"
				+ "from Kurir K\n"
				+ "where K.BrojIsporucenihPaketa >= ?");){
			
			ps.setInt(1, numberOfDeliveries);
			
			try(ResultSet rs = ps.executeQuery();) {
				if(rs.next())
					return rs.getBigDecimal(1);
			} catch (Exception e) {
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return new BigDecimal(0);
	}

	@Override
	public List<String> getCouriersWithStatus(int statusOfCourier) {
		List<String> listaPrimarnihKljuceva = new ArrayList<String>();
		try (PreparedStatement ps = connection.prepareStatement("select KorIme \n"
				+ "from Kurir\n"
				+ "where Status = statusOfCourier");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getString(1));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public boolean insertCourier(String courierUserName, String licencePlateNumber) {
		try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Kurir (KorIme, RegistracijaBroj, BrojIsporucenihPaketa, OstvarenProfit, Status) VALUES (?,?,0,0,0)");) {
			ps.setString(1, courierUserName);
			ps.setString(2, licencePlateNumber);

			ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return false;
	}

}

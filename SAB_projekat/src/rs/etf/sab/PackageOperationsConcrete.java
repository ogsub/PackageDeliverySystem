package rs.etf.sab;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import org.junit.Assert;

import rs.etf.sab.operations.PackageOperations;
import rs.etf.sab.tests.TestHandler;
import rs.etf.sab.tests.Util;

public class PackageOperationsConcrete implements PackageOperations {

	static Connection connection = DB.getInstance().getConnection();
	
	static private int pocetnaCena[] = {10, 25, 75};
	static private int tezinskiFaktor[] = {0, 1, 2};
	static private int cenaPoKg[] = {0, 100, 300};
	static private int cenaGorivaPoL[] = {15, 36, 32};
	
	class Par<X,Y> implements Pair<X, Y>{

		X first;
		Y second;
		
		public Par(X i, Y b) {
			first = i;
			second = b;
		}
		
		@Override
		public X getFirstParam() {
			return first;
		}

		@Override
		public Y getSecondParam() {
			return second;
		}
		
	}
	
	//////////////////////////////DODAJ OBAVEZNO TRIGGER ZA BRISANJE SVIH PONUDA
	@Override
	public boolean acceptAnOffer(int offerId) {
		String korIme;
		int idPaket;
		BigDecimal procenatCeneIsporuke;
		BigDecimal cena;
		
		//nadji kurira, cenu dostave, idPaketa
		try (PreparedStatement ps = connection.prepareStatement("Select KorIme, IdPaket, ProcenatCeneIsporuke from Ponuda where IdPonuda = ?");) {
			ps.setInt(1, offerId);

			try (ResultSet rs = ps.executeQuery();) {
				if (rs.next()) {
					korIme = rs.getString(1);
					idPaket = rs.getInt(2);
					procenatCeneIsporuke = rs.getBigDecimal(3);
				}
				else
					return false;
			} catch (Exception e) {
				return false;
			}
		} catch (SQLException e) {
			return false;
		}
		
		//nadji cenu
		try (PreparedStatement ps = connection.prepareStatement("Select Cena from ZahtevZaPrevoz where IdPaket = ?");) {
			ps.setInt(1, idPaket);

			try (ResultSet rs = ps.executeQuery();) {
				if (rs.next()) {
					cena = rs.getBigDecimal(1);
				}
				else
					return false;
			} catch (Exception e) {
				return false;
			}
		} catch (SQLException e) {
			return false;
		}
		
		try (PreparedStatement ps = connection.prepareStatement("UPDATE ZahtevZaPrevoz SET StatusIsporuke=1, Kurir=?, CenaDostave=?, VremePrihvatanjaZahteva=? WHERE IdPaket=?");) {
			ps.setString(1, korIme);
			ps.setBigDecimal(2, cena.multiply(procenatCeneIsporuke.add(new BigDecimal(100))).divide(new BigDecimal(100)));
			
			
			java.util.Date dt = new java.util.Date();

			java.text.SimpleDateFormat sdf = 
			     new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss:SSS");

			String currentTime = sdf.format(dt);
			ps.setString(3, currentTime);
			ps.setInt(4, idPaket);
			ps.executeUpdate();
			
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM Ponuda WHERE IdPonuda = ?");) {
			ps.setInt(1, offerId);
			int rowsAffected = ps.executeUpdate();
			return true;
		} catch (SQLException e) {
			return false;
		}
	}

	@Override
	public boolean changeType(int packageId, int newType) {
		try (PreparedStatement ps = connection.prepareStatement("UPDATE ZahtevZaPrevoz SET TipPaketa=?, Cena=? WHERE IdPaket=?");) {
			ps.setInt(1, newType);
			
			
			PreparedStatement ps2 = connection.prepareStatement("select TipPaketa, OpstinaSlanje, OpstinaPrijem, TezinaPaketa From ZahtevZaPrevoz where IdPaket = ?");
			ps2.setInt(1, packageId);
			ResultSet rs2 = ps2.executeQuery();
			BigDecimal cena = PackageOperationsConcrete.calculatePrice(rs2.getInt(2), rs2.getInt(3), rs2.getBigDecimal(4), newType);
			
			rs2.close();
			ps2.close();
			
			
			ps.setBigDecimal(2, cena);
			
			
			ps.setInt(3, packageId);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected == 1)
				return true;
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean changeWeight(int packageId, BigDecimal newWeight) {
		try (PreparedStatement ps = connection.prepareStatement("UPDATE ZahtevZaPrevoz SET TezinaPaketa=?, Cena=? WHERE IdPaket=?");) {
			ps.setBigDecimal(1, newWeight);
			
			
			PreparedStatement ps2 = connection.prepareStatement("select TipPaketa, OpstinaSlanje, OpstinaPrijem, TezinaPaketa From ZahtevZaPrevoz where IdPaket = ?");
			ps2.setInt(1, packageId);
			ResultSet rs2 = ps2.executeQuery();
			BigDecimal cena = PackageOperationsConcrete.calculatePrice(rs2.getInt(2), rs2.getInt(3), newWeight, rs2.getInt(1));
			
			rs2.close();
			ps2.close();
			
			
			ps.setBigDecimal(2, cena);
			
			
			ps.setInt(3, packageId);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected == 1)
				return true;
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return false;
	}

	@Override
	public boolean deletePackage(int packageId) {
		try (PreparedStatement ps = connection.prepareStatement("  DELETE FROM ZahtevZaPrevoz WHERE IdPaket = ?");) {
			ps.setInt(1, packageId);
			int rowsAffected = ps.executeUpdate();
			if (rowsAffected == 1)
				return true;
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return false;
	}

	@Override
	public int driveNextPackage(String courierUserName) {
		int statusKurir = -1;
		String registracija;
		int idIsporucenogPaketa;
		
		//dohvati status kurira i registraciju
		try (PreparedStatement ps = connection.prepareStatement("select Status, RegistracijaBroj from Kurir where KorIme = ?")){
			ps.setString(1, courierUserName);
			ResultSet rs = ps.executeQuery();
			if(rs.next()) {
				statusKurir = rs.getInt(1);
				registracija = rs.getString(2);
			}
			else
				return -2;
		} catch (Exception e) {
			return -2;
		}
		
		//ako ne vozi
		int zauzetaKola;
		if(statusKurir == 0) {
			//proveri da li su slobodna njegova kola
			try (PreparedStatement ps = connection.prepareStatement("select Zauzeta from Vozilo where RegistracijaBroj = ?")){
				ps.setString(1, registracija);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					zauzetaKola = rs.getInt(1);
				}
				else
					return -2;
			} catch (Exception e) {
				return -2;
			}
			
			if(zauzetaKola == 1) {
				return -1;
			}
			else {
				try (PreparedStatement ps = connection.prepareStatement("UPDATE Vozilo SET Zauzeta=1 WHERE RegistracijaBroj=?");) {
					ps.setString(1, registracija);		
					ps.executeUpdate();
					
				} catch (SQLException e) {
					return -2;
				}
				
				try (PreparedStatement ps = connection.prepareStatement("UPDATE Kurir SET Status=1 WHERE KorIme=?");) {
					ps.setString(1, courierUserName);		
					ps.executeUpdate();
					
				} catch (SQLException e) {
					return -2;
				}
				
				try (PreparedStatement ps = connection.prepareStatement("UPDATE ZahtevZaPrevoz SET StatusIsporuke=2 WHERE Kurir=? AND StatusIsporuke=1");) {
					ps.setString(1, courierUserName);		
					ps.executeUpdate();
					
				} catch (SQLException e) {
					return -2;
				}
			}
		}
		
		BigDecimal cenaDostave;
		int opstinaSlanje = 0, opstinaPrijem = 0;
		
		//dohvati trenutnu lokaciju kola da bi izracunao potrosnju do sledeceg mesta(voznja bez paketa)
		//prva voznja se ne racuna
		int trenutnaLokacijaOpstina = 0;
		if(statusKurir != 0) {
			try (PreparedStatement ps = connection.prepareStatement("select TrenutnaLokacija from Vozilo where RegistracijaBroj = ?")){
				ps.setString(1, registracija);
				ResultSet rs = ps.executeQuery();
				if(rs.next()) {
					trenutnaLokacijaOpstina = rs.getInt(1);
				}
				else
					return -2;
			} catch (Exception e) {
				return -2;
			}
		}
		
		//dohvati id paketa koji ces isporuciti i cenu dostave
		try (PreparedStatement ps = connection.prepareStatement("select top 1 IdPaket, CenaDostave, OpstinaSlanje, OpstinaPrijem from ZahtevZaPrevoz where Kurir=? AND StatusIsporuke=2 order by VremePrihvatanjaZahteva");) {
			ps.setString(1, courierUserName);		
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				idIsporucenogPaketa = rs.getInt(1);
				cenaDostave = rs.getBigDecimal(2);
				opstinaSlanje = rs.getInt(3);
				opstinaPrijem = rs.getInt(4);
			}
			else 
				return -2;
			
		} catch (SQLException e) {
			return -2;
		}
		//promeni status prvoprimljenog paketa
		try (PreparedStatement ps = connection.prepareStatement("UPDATE ZahtevZaPrevoz SET StatusIsporuke=3 WHERE IdPaket = (select top 1 IdPaket from ZahtevZaPrevoz where Kurir=? AND StatusIsporuke=2 order by VremePrihvatanjaZahteva)");) {
			ps.setString(1, courierUserName);		
			ps.executeUpdate();
			
		} catch (SQLException e) {
			return -2;
		}
		
		//provera ima li jos paketa
		int preostaliPaketi = 0;
		try (PreparedStatement ps = connection.prepareStatement("select count(IdPaket) from ZahtevZaPrevoz where Kurir = ? and StatusIsporuke = 2");) {
			ps.setString(1, courierUserName);
			
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				preostaliPaketi = rs.getInt(1);
			}
			rs.close();
		} catch (SQLException e) {
			return -2;
		}
		
		int updateStatusKurira;
		if(preostaliPaketi == 0) 
			updateStatusKurira = 0;
		else
			updateStatusKurira = 1;
		
		//update zarada i status
		try (PreparedStatement ps = connection.prepareStatement("UPDATE Kurir SET Status=?, "
				+ "BrojIsporucenihPaketa = (SELECT BrojIsporucenihPaketa WHERE KorIme = ?) + 1, "
				+ "OstvarenProfit = (SELECT OstvarenProfit WHERE KorIme = ?) + ? WHERE KorIme=?");) {
			ps.setInt(1, updateStatusKurira);
			ps.setString(2, courierUserName);	
			ps.setString(3, courierUserName);
			if(statusKurir != 0)
				ps.setBigDecimal(4, cenaDostave.subtract(PackageOperationsConcrete.calculateLoss(opstinaSlanje, opstinaPrijem, registracija)).subtract(PackageOperationsConcrete.calculateLoss(trenutnaLokacijaOpstina, opstinaSlanje, registracija)));
			else
				ps.setBigDecimal(4, cenaDostave.subtract(PackageOperationsConcrete.calculateLoss(opstinaSlanje, opstinaPrijem, registracija)));
			ps.setString(5, courierUserName);
			ps.executeUpdate();
			
		} catch (SQLException e) {
			return -2;
		}
		

		try (PreparedStatement ps = connection.prepareStatement("UPDATE Vozilo SET Zauzeta=?, TrenutnaLokacija=? WHERE RegistracijaBroj=?");) {
			ps.setInt(1, updateStatusKurira);
			ps.setInt(2, opstinaPrijem);
			ps.setString(3, registracija);	
			ps.executeUpdate();
			
		} catch (SQLException e) {
			return -2;
		}
		
		
		
		return idIsporucenogPaketa;
	}

	@Override
	public Date getAcceptanceTime(int packageId) {
		try (PreparedStatement ps = connection.prepareStatement("select VremePrihvatanjaZahteva\n"
				+ "from ZahtevZaPrevoz \n"
				+ "where IdPaket = ?");){
			
			ps.setInt(1, packageId);
			
			try(ResultSet rs = ps.executeQuery();) {
				if(rs.next()) {
					return rs.getDate(1);
				}
			} catch (Exception e) {
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return null;
	}

	@Override
	public List<Integer> getAllOffers() {
		List<Integer> listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select IdPonuda from Ponuda");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getInt(1));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Pair<Integer, BigDecimal>> getAllOffersForPackage(int packageId) {
		List<Pair<Integer, BigDecimal>> listaPrimarnihKljuceva = new ArrayList<>();
		try (PreparedStatement ps = connection.prepareStatement("select IdPonuda, ProcenatCeneIsporuke from Ponuda where IdPaket = ?");) {
			ps.setInt(1, packageId);
			
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				listaPrimarnihKljuceva.add(new Par<Integer, BigDecimal>(rs.getInt(1), rs.getBigDecimal(2)));
			}
			
			rs.close();
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Integer> getAllPackages() {
		List<Integer> listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select IdPaket from ZahtevZaPrevoz");
				ResultSet rs = ps.executeQuery();) {

			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getInt(1));
			}
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Integer> getAllPackagesWithSpecificType(int type) {
		List<Integer> listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select IdPaket from ZahtevZaPrevoz where TipPaketa = ?");) {
			ps.setInt(1, type);
			
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getInt(1));
			}
			rs.close();
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public Integer getDeliveryStatus(int packageId) {
		try (PreparedStatement ps = connection.prepareStatement("select StatusIsporuke from ZahtevZaPrevoz where IdPaket = ?");) {
			ps.setInt(1, packageId);
			
			try (ResultSet rs = ps.executeQuery();){
				if (rs.next()) {
					return rs.getInt(1);
				}
			}catch (Exception e) {
				// TODO: handle exception
			}

		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public List<Integer> getDrive(String courierUsername) {
		List<Integer> listaPrimarnihKljuceva = new ArrayList<Integer>();
		try (PreparedStatement ps = connection.prepareStatement("select IdPaket from ZahtevZaPrevoz where Kurir = ?");) {
			ps.setString(1, courierUsername);
			
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				listaPrimarnihKljuceva.add(rs.getInt(1));
			}
			rs.close();
			return listaPrimarnihKljuceva;

		} catch (SQLException e) {
			//e.printStackTrace();
		}
		return null;
	}

	@Override
	public BigDecimal getPriceOfDelivery(int packageId) {
		BigDecimal cenaDostave = new BigDecimal(0);
		int status = 0;
		
		try (PreparedStatement ps = connection.prepareStatement("select CenaDostave, StatusIsporuke from ZahtevZaPrevoz where IdPaket = ?");) {
			ps.setInt(1, packageId);
			
			try (ResultSet rs = ps.executeQuery();){
				if (rs.next()) {
					cenaDostave = rs.getBigDecimal(1);
					status = rs.getInt(2);
				}
			}catch (Exception e) {
				// TODO: handle exception
			}

		} catch (SQLException e) {
			//e.printStackTrace();
		}
		
		if(status != 0) {
			return cenaDostave;
		}
		return null;
	}

	static private BigDecimal calculateLoss(int districtFrom, int districtTo, String registracija) {
		int x1 = 0, y1 = 0;
		int x2 = 0, y2 = 0;
		
		try (PreparedStatement ps2 = connection.prepareStatement("select xKoordinata, yKoordinata from Opstina where IdOpstina = ?")){
			ps2.setInt(1, districtFrom);
			ResultSet rs2 = ps2.executeQuery();
			if(rs2.next()) {
				x1 = rs2.getInt(1);
				y1 = rs2.getInt(2);
			}
			rs2.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		try (PreparedStatement ps3 = connection.prepareStatement("select xKoordinata, yKoordinata from Opstina where IdOpstina = ?")){
			ps3.setInt(1, districtTo);
			ResultSet rs3 = ps3.executeQuery();
			if(rs3.next()) {
				x2 = rs3.getInt(1);
				y2 = rs3.getInt(2);
			}
			rs3.close();
		} catch (Exception e) {
			// TODO: handle exception
		}

		BigDecimal euclidianDistance = new BigDecimal(Math.sqrt(Math.pow(x1-x2, 2) + Math.pow(y1-y2, 2)));
		
		//dohvati potrosnju
		BigDecimal potrosnjaPoKm = new BigDecimal(0);
		int tipGoriva = 0;
		try (PreparedStatement ps3 = connection.prepareStatement("select Potrosnja, TipGoriva from Vozilo where RegistracijaBroj = ?")){
			ps3.setString(1, registracija);
			ResultSet rs3 = ps3.executeQuery();
			if(rs3.next()) {
				potrosnjaPoKm = rs3.getBigDecimal(1);
				tipGoriva = rs3.getInt(2);
			}
			rs3.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		return euclidianDistance.multiply(potrosnjaPoKm.multiply(new BigDecimal(cenaGorivaPoL[tipGoriva])));
	}
	
	static private BigDecimal calculatePrice(int districtFrom, int districtTo, BigDecimal weight, int packageType) {
		int x1 = 0, y1 = 0;
		int x2 = 0, y2 = 0;
		
		try (PreparedStatement ps2 = connection.prepareStatement("select xKoordinata, yKoordinata from Opstina where IdOpstina = ?")){
			ps2.setInt(1, districtFrom);
			ResultSet rs2 = ps2.executeQuery();
			if(rs2.next()) {
				x1 = rs2.getInt(1);
				y1 = rs2.getInt(2);
			}
			rs2.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		try (PreparedStatement ps3 = connection.prepareStatement("select xKoordinata, yKoordinata from Opstina where IdOpstina = ?")){
			ps3.setInt(1, districtTo);
			ResultSet rs3 = ps3.executeQuery();
			if(rs3.next()) {
				x2 = rs3.getInt(1);
				y2 = rs3.getInt(2);
			}
			rs3.close();
		} catch (Exception e) {
			// TODO: handle exception
		}
		
		BigDecimal f1 = new BigDecimal(tezinskiFaktor[packageType]).multiply(weight);
		BigDecimal f2 = f1.multiply(new BigDecimal(cenaPoKg[packageType]));
		BigDecimal f3 = f2.add(new BigDecimal(pocetnaCena[packageType]));
		BigDecimal euclidianDistance = new BigDecimal(Math.sqrt(Math.pow(x1-x2, 2) + Math.pow(y1-y2, 2)));
		BigDecimal finallRes = f3.multiply(euclidianDistance);
		
		return finallRes;
	}
	
	@Override
	public int insertPackage(int districtFrom, int districtTo, String userName, int packageType, BigDecimal weight) {
		try (PreparedStatement ps = connection.prepareStatement("UPDATE Korisnik SET BrPoslatihPaketa= (Select BrPoslatihPaketa FROM Korisnik WHERE KorIme = ?) + 1 WHERE KorIme=?");) {
			ps.setString(1, userName);	
			ps.setString(2, userName);	
			ps.executeUpdate();
			
		} catch (SQLException e) {
			return -1;
		}
		
		try (PreparedStatement ps = connection.prepareStatement("INSERT INTO ZahtevZaPrevoz (OpstinaSlanje, OpstinaPrijem, Posiljalac, TipPaketa, TezinaPaketa, StatusIsporuke, Cena) VALUES (?,?,?,?,?,?,?)",
				Statement.RETURN_GENERATED_KEYS);) {
			ps.setInt(1, districtFrom);
			ps.setInt(2, districtTo);
			ps.setString(3, userName);
			ps.setInt(4, packageType);
			ps.setBigDecimal(5, weight);
			ps.setInt(6, 0);
			
			BigDecimal finalRes = PackageOperationsConcrete.calculatePrice(districtFrom, districtTo, weight, packageType);
			
			ps.setBigDecimal(7, finalRes);

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

	@Override
	public int insertTransportOffer(String couriersUserName, int packageId, BigDecimal pricePercentage) {
		int status = 1;
		try (PreparedStatement ps = connection.prepareStatement("Select Status from Kurir where KorIme = ?");) {
			ps.setString(1, couriersUserName);

			try (ResultSet rs = ps.executeQuery();) {
				if (rs.next()) {
					status = rs.getInt(1);
				}
			} catch (Exception e) {
				//e.printStackTrace();
			}
		} catch (SQLException e) {
			//e.printStackTrace();
		}
		
		if(status == 0) {
			try (PreparedStatement ps = connection.prepareStatement("INSERT INTO Ponuda (KorIme, IdPaket, ProcenatCeneIsporuke) VALUES (?,?,?)",
					Statement.RETURN_GENERATED_KEYS);) {
				ps.setString(1, couriersUserName);
				ps.setInt(2, packageId);
				if(pricePercentage.compareTo(new BigDecimal(0)) == 0) {
					pricePercentage = new BigDecimal(Math.random() * 10);
				}
				ps.setBigDecimal(3, pricePercentage);
	
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
		return -1;
	}
	
	public static void main(String[] args) {
		GeneralOperationsConcrete general = new GeneralOperationsConcrete();
        
        general.eraseAll();
		
		UserOperationsConcrete userOperations = new UserOperationsConcrete();
		VehicleOperationsConcrete vehicleOperations = new VehicleOperationsConcrete();
		CourierRequestOperationConcrete courierRequestOperation = new CourierRequestOperationConcrete();
		CourierOperationsConcrete courierOperations = new CourierOperationsConcrete();
		CityOperationsConcrete cityOperations = new CityOperationsConcrete();
		DistrictOperationsConcrete districtOperations = new DistrictOperationsConcrete();
		PackageOperationsConcrete packageOperations = new PackageOperationsConcrete();
		
		final String courierLastName = "Ckalja";
        final String courierFirstName = "Pero";
        final String courierUsername = "perkan";
        String password = "sabi2018";
        userOperations.insertUser(courierUsername, courierFirstName, courierLastName, password);
        final String licencePlate = "BG323WE";
        final int fuelType = 0;
        final BigDecimal fuelConsumption = new BigDecimal(8.3);
        vehicleOperations.insertVehicle(licencePlate, fuelType, fuelConsumption);
        courierRequestOperation.insertCourierRequest(courierUsername, licencePlate);
        courierRequestOperation.grantRequest(courierUsername);
        Assert.assertTrue(courierOperations.getAllCouriers().contains(courierUsername));
        final String senderUsername = "masa";
        final String senderFirstName = "Masana";
        final String senderLastName = "Leposava";
        password = "lepasampasta1";
        userOperations.insertUser(senderUsername, senderFirstName, senderLastName, password);
        final int cityId = cityOperations.insertCity("Novo Milosevo", "21234");
        final int cordXd1 = 10;
        final int cordYd1 = 2;
        final int districtIdOne = districtOperations.insertDistrict("Novo Milosevo", cityId, cordXd1, cordYd1);
        final int cordXd2 = 2;
        final int cordYd2 = 10;
        final int districtIdTwo = districtOperations.insertDistrict("Vojinovica", cityId, cordXd2, cordYd2);
        final int type1 = 0;
        final BigDecimal weight1 = new BigDecimal(123);
        final int packageId1 = packageOperations.insertPackage(districtIdOne, districtIdTwo, courierUsername, type1, weight1);
        final BigDecimal packageOnePrice = Util.getPackagePrice(type1, weight1, Util.euclidean(cordXd1, cordYd1, cordXd2, cordYd2), new BigDecimal(5));
        int offerId = packageOperations.insertTransportOffer(courierUsername, packageId1, new BigDecimal(5));
        packageOperations.insertTransportOffer(courierUsername, packageId1, new BigDecimal(7));
        packageOperations.acceptAnOffer(offerId);
        final int type2 = 1;
        final BigDecimal weight2 = new BigDecimal(321);
        final int packageId2 = packageOperations.insertPackage(districtIdTwo, districtIdOne, courierUsername, type2, weight2);
        final BigDecimal packageTwoPrice = Util.getPackagePrice(type2, weight2, Util.euclidean(cordXd1, cordYd1, cordXd2, cordYd2), new BigDecimal(5));
        offerId = packageOperations.insertTransportOffer(courierUsername, packageId2, new BigDecimal(5));
        packageOperations.acceptAnOffer(offerId);
        final int type3 = 1;
        final BigDecimal weight3 = new BigDecimal(222);
        final int packageId3 = packageOperations.insertPackage(districtIdTwo, districtIdOne, courierUsername, type3, weight3);
        final BigDecimal packageThreePrice = Util.getPackagePrice(type3, weight3, Util.euclidean(cordXd1, cordYd1, cordXd2, cordYd2), new BigDecimal(5));
        offerId = packageOperations.insertTransportOffer(courierUsername, packageId3, new BigDecimal(5));
        packageOperations.acceptAnOffer(offerId);
        
        //Assert.assertEquals(1L, packageOperations.getDeliveryStatus(packageId1));
        if(1L == packageOperations.getDeliveryStatus(packageId1)) {
        	System.out.println("DOBRO JE");
        }
        else {
        	System.out.println("NIJE DOBRO");
        }
        
        Assert.assertEquals(packageId1, packageOperations.driveNextPackage(courierUsername));
       
        //Assert.assertEquals(3L, packageOperations.getDeliveryStatus(packageId1));
        if(3L == packageOperations.getDeliveryStatus(packageId1)) {
        	System.out.println("DOBRO JE");
        }
        else {
        	System.out.println("NIJE DOBRO");
        }
        
        //Assert.assertEquals(2L, packageOperations.getDeliveryStatus(packageId2));
        if(2L == packageOperations.getDeliveryStatus(packageId2)) {
        	System.out.println("DOBRO JE");
        }
        else {
        	System.out.println("NIJE DOBRO");
        }
        
        Assert.assertEquals(packageId2, packageOperations.driveNextPackage(courierUsername));
        
        //Assert.assertEquals(3L, packageOperations.getDeliveryStatus(packageId2));
        if(3L == packageOperations.getDeliveryStatus(packageId2)) {
        	System.out.println("DOBRO JE");
        }
        else {
        	System.out.println("NIJE DOBRO");
        }
        
        //Assert.assertEquals(2L, packageOperations.getDeliveryStatus(packageId3));
        if(2L == packageOperations.getDeliveryStatus(packageId3)) {
        	System.out.println("DOBRO JE");
        }
        else {
        	System.out.println("NIJE DOBRO");
        }
        
        Assert.assertEquals(packageId3, packageOperations.driveNextPackage(courierUsername));
        
        //Assert.assertEquals(3L, packageOperations.getDeliveryStatus(packageId3));
        if(3L == packageOperations.getDeliveryStatus(packageId3)) {
        	System.out.println("DOBRO JE");
        }
        else {
        	System.out.println("NIJE DOBRO");
        }
        
        final BigDecimal gain = packageOnePrice.add(packageTwoPrice).add(packageThreePrice);
        final BigDecimal loss = new BigDecimal(Util.euclidean(cordXd1, cordYd1, cordXd2, cordYd2) * 4.0 * 15.0).multiply(fuelConsumption);
        final BigDecimal actual = courierOperations.getAverageCourierProfit(0);
        Assert.assertTrue(gain.subtract(loss).compareTo(actual.multiply(new BigDecimal(1.001))) < 0);
        Assert.assertTrue(gain.subtract(loss).compareTo(actual.multiply(new BigDecimal(0.999))) > 0);
	}

}

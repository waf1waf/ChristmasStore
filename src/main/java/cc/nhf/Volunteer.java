package cc.nhf;

import org.jetbrains.annotations.NotNull;

import java.util.List;

public class Volunteer implements Comparable<Volunteer> {
	private static final ReservationManager reservationManager = ReservationManager.getInstance();
	private int id;
	private String lastName = "";
	private String firstName = "";
	private String emailAddress = "";
	private String phoneNumber = "";
	private int organizationId = 1;
	private String otherOrganization = "";
	private int adults;
	private int children;
	private int youngest;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getLastName() {
		return lastName;
	}

	void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getEmailAddress() {
		return emailAddress;
	}

	void setEmailAddress(String emailAddress) {
		this.emailAddress = emailAddress;
	}

	public String getPhoneNumber() {
		return phoneNumber;
	}

	void setPhoneNumber(String phoneNumber) {
		this.phoneNumber = phoneNumber;
	}

	public int getOrganizationId() {
		return this.organizationId;
	}

	void setOrganizationId(int organizationId) {
		this.organizationId = organizationId;
	}

	public String getOtherOrganization() {
		return this.otherOrganization;
	}

	void setOtherOrganization(String otherOrganization) {
		this.otherOrganization = otherOrganization;
	}

	public int isWorkingShift(int shiftID) {
	    List<Reservation> reservations = reservationManager.getReservationsByVolunteer(id);
	    for (Reservation reservation : reservations) {
	        if (reservation.getShift().getId() == shiftID) {
	            return reservation.getArea().getId();
            }
        }
        return -1;
	}

	public int getAdults() {
		return adults;
	}

	public int getPeople() {
		return adults + children;
	}

	void setAdults(int adults) {
		this.adults = adults;
	}

	public int getChildren() {
		return children;
	}

	void setChildren(int children) {
		this.children = children;
	}

	@Override
	public String toString() {
		return "[\"" + lastName + "\",\"" + firstName + "\",\"" + emailAddress + "\",\"" + phoneNumber + "\"," + adults + "," + children + "," + youngest + "]";
	}

	@Override
	public int compareTo(@NotNull Volunteer p) {
		return (this.getLastName() + "_" + this.getFirstName() + "_" + this.getEmailAddress() + "_" + adults + "_" + children + "_" + youngest).compareTo(p.getLastName() + "_" + p.getFirstName() + "_" + p.getEmailAddress() + "_" + p.getAdults() + "_" + p.getChildren() + "_" + p.getYoungest());
	}

	public int getYoungest() {
		return youngest;
	}

	void setYoungest(int youngest) {
		this.youngest = youngest;
	}

    public String getReservationsString() {
		StringBuilder reservationsString = new StringBuilder();
		for (Reservation reservation : reservationManager.getReservationsByVolunteer(id)) {
            reservationsString.append("You have scheduled ").append(reservation.getCount()).append(reservation.getCount() == 1 ? " volunteer" : " volunteers").append(" to work in the ").append(reservation.getArea().getName()).append(" area on ").append(reservation.getShift().getName()).append(".\n");
		}
        return reservationsString.toString();
    }

    public int getReservationCount() {
		return reservationManager.getReservationCountByVolunteer(this);
    }
}

package cc.nhf;

import org.jetbrains.annotations.NotNull;

import org.apache.log4j.Logger;

public class Reservation implements Comparable<Reservation> {
	private final int id;
	private final Volunteer volunteer;
	private final Area area;

	private static final VolunteerManager volunteerManager = VolunteerManager.getInstance();
	private static final AreaManager areaManager = AreaManager.getInstance();
	private static final ShiftManager shiftManager = ShiftManager.getInstance();

    private final Shift shift;
	private int count;
	private static final Logger logger = Logger.getLogger("Reservation");

	public Reservation(int id, int volunteerId, int areaId, int shiftId, int count) {
		super();
		this.id = id;
		this.volunteer = volunteerManager.getVolunteer(volunteerId);
		this.area = areaManager.getAreaById(areaId);
		this.shift = shiftManager.getShift(shiftId);
		this.count = count;
	}

	public int getId() {
		return id;
	}

    public Volunteer getVolunteer() {
		return volunteer;
	}

    public Area getArea() {
		return area;
	}

    public Shift getShift() {
		return shift;
	}

    public int getCount() {
		return count;
	}

	@Override
	public int compareTo(@NotNull Reservation r) {
		if (this.getArea() == null) {
			logger.warn("this reservation has no area, " + this);
			return 1;
		}
		if (r.getArea() == null) {
			logger.warn("r has no area, " + r);
			return 1;
		}
		if (this.getArea().getName() == null) {
			logger.warn("this reservation area has no name, " + this.getArea());
			return 1;
		}
		if (r.getArea().getName() == null) {
            logger.warn("r reservation area has no name, " + r.getArea());
			return 1;
		}
		int compareTo = this.getArea().getName().compareTo(r.getArea().getName());
		if (compareTo != 0) {
			return compareTo;
		}
		compareTo = this.getShift().compareTo(r.getShift());
		if (compareTo != 0) {
			return compareTo;
		}
		return this.getVolunteer().compareTo(r.getVolunteer());
	}

	public String toString() {
		return "[" + volunteer + "," + area + "," + shift + "," + count + "'";
	}

	public void setCount(int count) {
		this.count = count;
	}
}

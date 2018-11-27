package cc.nhf;

public class Need {
	private final int areaId;
	private final int shiftId;
	private int count;

	public Need(int areaId, int shiftId, int count) {
		this.areaId = areaId;
		this.shiftId = shiftId;
		this.count = count;
	}
	public int getCount() {
	return count;
}

	@Override
	public String toString() {
		return "[" + shiftId + "," + areaId + "," + count + "]";
	}

	public void setCount(int count) {
		this.count = count;
	}
}

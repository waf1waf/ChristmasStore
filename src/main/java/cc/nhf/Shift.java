package cc.nhf;

import org.jetbrains.annotations.NotNull;

public class Shift implements Comparable<Shift> {
	private int id;
	private int pos;
	private String name;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	int getPos() {
		return pos;
	}

	void setPos(int pos) {
		this.pos = pos;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "[" + id + "," + pos + ",\"" + name + "\"]";
	}

	@Override
	public int compareTo(@NotNull Shift s) {
		return Integer.compare(this.pos, s.getPos());
	}
}

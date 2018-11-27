package cc.nhf;

import org.jetbrains.annotations.NotNull;

public class Organization implements Comparable<Organization> {
	private int id;
	private String name;

	public Organization() {
	}

	public Organization(int id, String name) {
		this.id = id;
		this.name = name;
	}

	public int getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "[" + id + ",\"" + name + "]";
	}

	@Override
	public int compareTo(@NotNull Organization a) {
		return this.getName().compareTo(a.getName());
	}
}

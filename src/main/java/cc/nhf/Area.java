package cc.nhf;

import org.jetbrains.annotations.NotNull;

public class Area implements Comparable<Area> {
	private int id;
	private String name;
	private String description;
	private int minimumAge;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	void setDescription(String description) {
		this.description = description;
	}

	public int getMinimumAge() {
		return minimumAge;
	}

	void setMinimumAge(int minimumAge) {
		this.minimumAge = minimumAge;
	}

	@Override
	public String toString() {
		return "[" + id + ",\"" + name + "\"," + minimumAge + "]";
	}

	@Override
	public int compareTo(@NotNull Area a) {
		return this.getName().compareTo(a.getName());
	}
}
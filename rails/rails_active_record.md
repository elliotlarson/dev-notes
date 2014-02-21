# Active Record Notes

#### pulling out records grouped by created at month

	Project.select([:id, :created_at]).order(:created_at).group_by { |p| p.created_at.month }
	
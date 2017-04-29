class KeChengXianZhi < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :kechengmingcheng, :string
    add_column :jobs, :zhangjie, :integer
    add_column :jobs, :step, :integer
  end
end

class AddExternalManifestUrlToAppVersions < ActiveRecord::Migration
  def change
    add_column :app_versions, :external_manifest_url, :string
  end
end

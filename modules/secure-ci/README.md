<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional\_substitutions | Parameters to be substituted in the build specification. All keys should begin with an underscore. | `map(string)` | `{}` | no |
| app\_build\_trigger\_yaml | Name of application cloudbuild yaml file | `string` | n/a | yes |
| app\_source\_repo | Name of repo that contains app source code along with cloudbuild yaml | `string` | `"app-source"` | no |
| attestor\_names\_prefix | A list of Cloud Source Repos to be created to hold app infra Terraform configs | `list(string)` | n/a | yes |
| build\_image\_config\_yaml | Name of image builder yaml file | `string` | n/a | yes |
| cloudbuild\_service\_account\_roles | IAM roles given to the Cloud Build service account to enable security scanning operations | `list(string)` | <pre>[<br>  "roles/artifactregistry.admin",<br>  "roles/binaryauthorization.attestorsVerifier",<br>  "roles/cloudbuild.builds.builder",<br>  "roles/cloudkms.cryptoOperator",<br>  "roles/containeranalysis.notes.attacher",<br>  "roles/containeranalysis.notes.occurrences.viewer",<br>  "roles/containeranalysis.notes.viewer",<br>  "roles/source.writer",<br>  "roles/storage.admin"<br>]</pre> | no |
| gar\_repo\_name\_suffix | Docker artifact regitery repo to store app build images | `string` | `"app-image-repo"` | no |
| manifest\_dry\_repo | Name of repo that contains template K8s manifests files | `string` | `"app-dry-manifests"` | no |
| manifest\_wet\_repo | Name of repo that will receive hydrated K8s manifests files | `string` | `"app-wet-manifests"` | no |
| primary\_location | Region used for key-ring | `string` | n/a | yes |
| project\_id | Project ID for CICD Pipeline Project | `string` | n/a | yes |
| runner\_build\_folder | Path to the source folder for the cloud builds submit command | `string` | n/a | yes |
| trigger\_branch\_name | A regular expression to match one or more branches for the build trigger. | `string` | n/a | yes |
| use\_tf\_google\_credentials\_env\_var | Optional GOOGLE\_CREDENTIALS environment variable to be activated. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| app\_artifact\_repo | GAR Repo created to store runner images |
| bin\_auth\_attestor\_names | Names of Attestors |
| bin\_auth\_attestor\_project\_id | Project ID where attestors get created |
| build\_trigger\_name | The name of the cloud build trigger for the app source repo. |
| cache\_bucket\_name | The name of the storage bucket for cloud build. |
| source\_repo\_names | Name of the created CSR repos |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
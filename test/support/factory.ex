defmodule Opencov.Factory do
  use ExMachina.Ecto, repo: Opencov.Repo

  def factory(:project) do
    project = %Opencov.Project{
      name: sequence(:name, &("name-#{&1}")),
      base_url: sequence(:base_url, &("https://github.com/tuvistavie/name-#{&1}"))
    }
    Map.merge(project, Opencov.Project.changeset(project).changes)
  end

  def factory(:settings) do
    %Opencov.Settings{
      signup_enabled: false,
      restricted_signup_domains: nil,
      default_project_visibility: "internal"
    }
  end


  def factory(:user) do
    %Opencov.User{
      name: sequence(:name, &("name-#{&1}")),
      email: sequence(:email, &("email-#{&1}@example.com")),
      password: "my-secure-password"
    }
  end

  def factory(:build) do
    attrs = %{
      build_number: sequence(:build_number, &(&1)),
    }
    changeset = Opencov.CreateBuildService.make_changeset(create(:project), attrs)
    Map.merge(changeset.model, changeset.changes)
  end

  def factory(:job) do
    %Opencov.Job{
      job_number: sequence(:job_number, &(&1)),
      build: build(:build)
    }
  end

  def factory(:file) do
    model = %Opencov.File{job: build(:job)}
    attrs = %{
      name: sequence(:name, &("file-#{&1}")),
      source: "return 0",
      coverage_lines: []
    }
    changeset = Opencov.File.changeset(model, attrs)
    Map.merge(changeset.model, changeset.changes)
  end

  def with_project(build) do
    project = create(:project)
    %{build | project_id: project.id}
  end

  def with_secure_password(user, password) do
    changeset = Opencov.User.changeset(user, %{password: password})
    %{user | password_digest: changeset.changes[:password_digest]}
  end

  def confirmed_user(user) do
    %{user | confirmed_at: Timex.Date.now, password_initialized: true}
  end
end

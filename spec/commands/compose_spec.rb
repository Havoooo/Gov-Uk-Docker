require "spec_helper"
require_relative "../../lib/commands/compose"

describe Commands::Compose do
  let(:fake_system) { double }
  let(:config_directory) { "spec/fixtures" }
  let(:verbose) { nil }

  subject { described_class.new(nil, config_directory, fake_system) }

  context "when in verbose mode" do
    let(:verbose) { true }
    it "calls docker-compose with the correct configure files and arguments" do
      expect(fake_system).to receive(:call).with(
        "docker-compose",
        "-f", "spec/fixtures/docker-compose.yml",
        "-f", "spec/fixtures/services/example-service/docker-compose.yml",
        "fake args"
      )

      subject.call(verbose, "fake args")
    end

    it "outputs the full list of docker compose files" do
      expect(fake_system).to receive(:call).with(
        "docker-compose",
        "-f", "spec/fixtures/docker-compose.yml",
        "-f", "spec/fixtures/services/example-service/docker-compose.yml",
        "test args"
      )

      expect { subject.call(verbose, "test args") }.
        to output("docker-compose -f spec/fixtures/docker-compose.yml -f spec/fixtures/services/example-service/docker-compose.yml test args\n").to_stdout
    end
  end

  context "when in silent mode" do
    let(:verbose) { false }
    it "outputs a truncated list of docker commands" do
      expect(fake_system).to receive(:call).with(
        "docker-compose",
        "-f", "spec/fixtures/docker-compose.yml",
        "-f", "spec/fixtures/services/example-service/docker-compose.yml",
        "test args"
      )

      expect { subject.call(verbose, "test args") }.
       to output("docker-compose -f [...] test args\n").to_stdout
    end
  end
end
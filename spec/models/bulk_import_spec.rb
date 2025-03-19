require 'rails_helper'

RSpec.describe BulkImport, type: :model do
  describe "#Valid?" do
    context "presence" do
      it { should validate_presence_of(:file) }
    end

    context "numericality" do
      it { should validate_numericality_of(:total_records).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:processed_records).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:success_records).is_greater_than_or_equal_to(0) }
      it { should validate_numericality_of(:error_records).is_greater_than_or_equal_to(0) }
    end

    context "custom validations" do
      it 'should only allow CSV and TXT files' do
        bulk_import = build(:bulk_import)
        bulk_import.file.attach(io: File.open('spec/support/files/logo.png'), filename: 'logo.png', content_type: 'image/png')

        expect(bulk_import).not_to be_valid
      end

      it 'should allow txt files' do
        bulk_import = build(:bulk_import)
        bulk_import.file.attach(io: File.open('spec/support/files/text.txt'), filename: 'text.txt', content_type: 'text/plain')

        expect(bulk_import).to be_valid
      end

      it 'should allow csv files' do
        bulk_import = build(:bulk_import)
        bulk_import.file.attach(io: File.open('spec/support/files/data.csv'), filename: 'data.csv', content_type: 'text/csv')

        expect(bulk_import).to be_valid
      end
    end
  end

  context "defaults" do
    it 'should default to 0' do
      expect(BulkImport.new.total_records).to eq(0)
      expect(BulkImport.new.processed_records).to eq(0)
      expect(BulkImport.new.success_records).to eq(0)
      expect(BulkImport.new.error_records).to eq(0)
    end
  end

  context "enum" do
    it { define_enum_for(:status).with_values(pending: 0, processing: 10, completed: 20, failed: 30) }

    it 'should default to pending' do
      expect(BulkImport.new.status).to eq('pending')
    end
  end

  context '#update_progress' do
    it 'broadcasts the progress update when the record is updated' do
      bulk_import = create(:bulk_import, file: fixture_file_upload('spec/support/files/text.txt', 'text/plain'))

      expect(bulk_import).to receive(:broadcast_replace_to).with(
        "bulk_import_#{bulk_import.id}",
        target: "progress_bar",
        partial: "bulk_imports/progress",
        locals: { bulk_import: bulk_import }
      )

      bulk_import.update!(total_records: 10)
    end
  end

  context "associations" do
    it { should have_one_attached(:file) }
    it { should have_many(:import_errors) }
  end

  context "#human_status" do
    it 'should return the humanized status' do
      bulk_import = build(:bulk_import, status: 0)

      expect(bulk_import.human_status).to eq('Pendente')
    end

    it 'should return the humanized status' do
      bulk_import = build(:bulk_import, status: 10)

      expect(bulk_import.human_status).to eq('Processando')
    end

    it 'should return the humanized status' do
      bulk_import = build(:bulk_import, status: 20)

      expect(bulk_import.human_status).to eq('Concluído')
    end

    it 'should return the humanized status' do
      bulk_import = build(:bulk_import, status: 30)

      expect(bulk_import.human_status).to eq('Falhou')
    end
  end

  context '#generate_report' do
    it 'returns the report' do
      bulk_import = BulkImport.new(
        total_records: 5,
        processed_records: 5,
        success_records: 4,
        error_records: 1,
        status: 20
      )

      bulk_import.file.attach(io: File.open('spec/support/files/text.txt'), filename: 'text.txt', content_type: 'text/plain')
      bulk_import.save

      bulk_import.import_errors.create(
        line_number: 3,
        error_message: 'Teste de Erro',
        line_content: 'Teste de Conteúdo',
        bulk_import: bulk_import
      )

      expected_report = <<~REPORT
        Relatório de Importação - ID: #{bulk_import.id}
        =====================================
        📅 Data de Criação: #{bulk_import.created_at.strftime("%d/%m/%Y %H:%M:%S")}
        📂 Arquivo Importado: text.txt

        📊 Total de Registros: 5
        ✅ Registros Sucesso: 4
        ❌ Registros com Erro: 1
        📦 Registros Processados: 5

        🔄 Status Final: Concluído

        Erros Encontrados:
        Linha 3: Teste de Erro
      REPORT

      expect(bulk_import.generate_report).to eq(expected_report)
    end
  end
end

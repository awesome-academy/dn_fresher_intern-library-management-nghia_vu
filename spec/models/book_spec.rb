require "rails_helper"

RSpec.describe Book, type: :model do
  describe "associations" do
    it "must belong to shop" do
      is_expected.to belong_to :shop
    end
    it "must belong to category" do
      is_expected.to belong_to :category
    end
    it "has many order_details" do
      is_expected.to have_many :order_details
    end
  end

  describe "validate" do
    context "title" do
      it "when nil is invalid" do
        expect validate_presence_of(:title).with_message I18n.t("activerecord.errors.models.book.attributes.title.blank")
      end
    end
  end

  describe "scope" do
    let!(:book){FactoryBot.create :book}
    let!(:book_2){FactoryBot.create :book, title: "Lot of Book"}
    let!(:book_3){FactoryBot.create :book}
    context ".recent_books" do
      it "return books has sort DESC" do
        expect Book.all.recent_books.should eq [book_3, book_2, book]
      end
    end

    context ".by_book_ids" do
      context "when id = 2" do
        it "return book_2" do
          expect Book.by_book_ids(2).should include book_2
        end
      end

      context "when id is nil" do
        it "return nil" do
          expect(Book.by_book_ids("")).to eq []
        end
      end
    end
  end
end

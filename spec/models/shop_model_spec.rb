RSpec.describe Shop, type: :model do
  describe "Associations" do
    it "belongs to user" do
      is_expected.to belong_to(:user)
    end

    it "has many books" do
      is_expected.to have_many(:books)
    end

    it "has many orders" do
      is_expected.to have_many(:orders)
    end
  end

  describe "Validations" do
    subject { FactoryBot.create :shop }
    
    it "is valid with valid attributes" do
      is_expected.to be_valid
    end
    
    it "is not valid without a name" do
      subject.name = nil
      is_expected.to_not be_valid
    end

    it "is not valid with repeat name" do
      FactoryBot.create :shop, name: "nghia123123"
      subject.name = "nghia123123"
      is_expected.to_not be_valid
    end
    
    it "is not valid with too long description" do
      subject.description = "a" * 256
      is_expected.to_not be_valid
    end
  end

  describe "Methods" do
    let(:book) {FactoryBot.create :book}
    let(:order) {FactoryBot.create :order}

    context "#all_books" do
      it "return all books of shop" do
        expect(book.shop.all_books).to eq [book]
      end
    end

    context "#all_orders" do
      it "return all orders of shop" do
        expect(order.shop.all_orders).to eq [order]
      end
    end
  end

  describe "Scopes" do
    subject { FactoryBot.create :shop }

    describe ".search_by_name" do
      it "includes shops contain keyword" do
        expect(Shop.search_by_name(subject.name)).to include(subject)
      end
    end
  end
end

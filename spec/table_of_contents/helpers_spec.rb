require 'spec_helper'

describe GovukTechDocs::TableOfContents::Helpers do
  describe '#single_page_table_of_contents' do
    class Subject
      include GovukTechDocs::TableOfContents::Helpers
    end

    subject { Subject.new }

    it 'builds a table of contents from html' do
      html = %{
        <h1 id="fruit">Fruit</h1>
        <h1 id="apples">Apples</h1>
        <p>A fruit</p>
        <h2 id="apple-recipes">Apple recipes</h2>
        <p>Get some apples..</p>
      }

      expected_single_page_table_of_contents = %{
<ul>
  <li>
    <a href="#fruit">Fruit</a>
  </li>
  <li>
    <a href="#apples">Apples</a>
    <ul>
      <li>
        <a href="#apple-recipes">Apple recipes</a>
      </li>
    </ul>
  </li>
</ul>
      }

      expect(subject.single_page_table_of_contents(html).strip).to eq(expected_single_page_table_of_contents.strip)
    end

    it 'builds a table of contents from html when headings suddenly change by more than one size' do
      html = %{
        <h1 id="fruit">Fruit</h1>
        <h3 id="apples">Apples</h3>
        <p>A fruit</p>
        <h4 id="apple-recipes">Apple recipes</h4>
        <p>Get some apples..</p>
        <h1 id="bread">Bread</h1>
      }

      expected_single_page_table_of_contents = %{
<ul>
  <li>
    <a href="#fruit">Fruit</a>
    <ul>
      <li>
        <ul>
          <li>
            <a href="#apples">Apples</a>
            <ul>
              <li>
                <a href="#apple-recipes">Apple recipes</a>
              </li>
            </ul>
          </li>
        </ul>
      </li>
    </ul>
  </li>
  <li>
    <a href="#bread">Bread</a>
  </li>
</ul>
      }

      expect(subject.single_page_table_of_contents(html).strip).to eq(expected_single_page_table_of_contents.strip)
    end

    it 'builds a table of contents from HTML without an h1' do
      html = %{
        <h2 id="apples">Apples</h3>
      }

      expect { subject.single_page_table_of_contents(html).strip }.to raise_error(RuntimeError)
    end
  end
end

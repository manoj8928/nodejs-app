const chai = require('chai');
const chaiHttp = require('chai-http');
const app = require('../app/index');  // adjust the path to your app's entry point

const { expect } = chai;

chai.use(chaiHttp);

describe('API Endpoints', () => {
  describe('GET /status', () => {
    it('should return API status', (done) => {
      chai.request(app)
        .get('/status')
        .end((err, res) => {
          expect(res).to.have.status(200);
          expect(res.body.status).to.equal('API is working');
          done();
        });
    });
  });
});

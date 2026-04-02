exports.getUsers = (req, res) => {
  res.json([{ id: 1, name: 'Andre' }]);
};

exports.getUserById = (req, res) => {
  res.json({ id: req.params.id, name: 'Andre' });
};

exports.createUser = (req, res) => {
  res.json({
    message: 'User created',
    data: req.body
  });
};